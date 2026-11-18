# A pure Nix library that handles the treefmt configuration.
let
  # The base module configuration that generates and wraps the treefmt config
  # with Nix.
  module-options = ./module-options.nix;

  # Program to formatter mapping
  programs = import ./programs.nix;

  writeIfChanged =
    pkgs: name: exe: printsResult:
    let
      input = if printsResult == "fromStdin" then ''< "$file"'' else ''"$file"'';
    in
    assert builtins.elem printsResult [
      "fromArgument"
      "fromStdin"
    ];
    pkgs.writeShellApplication {
      name = "${name}-wrapper";
      runtimeInputs = [ pkgs.diffutils ];
      text = ''
        options=()
        while [[ $# -gt 0 && $1 != -- ]]; do
          options+=("$1")
          shift
        done
        shift
        temp=$(mktemp)
        trap 'rm "$temp"' EXIT
        for file in "$@"; do
          ${if pkgs.lib.isString exe then exe else pkgs.lib.getExe exe} "''${options[@]}" ${input} > "$temp"
          # cp keeps the file's mode and follows symlinks, unlike mv
          if ! cmp -s "$file" "$temp"; then
            cp "$temp" "$file"
          fi
        done
      '';
    };

  mkFormatterModule =
    {
      name,
      package ? name,
      mainProgram ? null,
      args ? [ ],
      stdinArgs ? null,
      # null (default): the formatter edits the file in place
      # "fromArgument": it prints the result of the file passed as last argument
      # "fromStdin": it prints the result of the file piped to stdin
      printsResult ? null,
      includes ? [ ],
      excludes ? [ ],
    }:
    {
      pkgs,
      lib,
      config,
      options,
      ...
    }:
    let
      cfg = config.programs.${name};
      opt = options.programs.${name};
    in
    {
      options.programs.${name} = {
        enable = lib.mkEnableOption name;

        package = lib.mkPackageOption pkgs package { };

        includes = lib.mkOption {
          description = "Path / file patterns to include";
          type = lib.types.listOf lib.types.str;
          default = includes;
        };

        excludes = lib.mkOption {
          description = "Path / file patterns to exclude";
          type = lib.types.listOf lib.types.str;
          default = excludes;
        };

        priority = lib.mkOption {
          description = "Priority";
          type = lib.types.nullOr lib.types.int;
          default = null;
        };

        finalPackage = lib.mkOption {
          type = lib.types.package;
          readOnly = true;
          description = "Resulting `${name}` package bundled with plugins, if any.";
        };
      };

      config = lib.mkIf cfg.enable {
        settings.formatter.${name} = {
          command = lib.mkDefault (
            let
              pkg = if opt.finalPackage.isDefined then cfg.finalPackage else cfg.package;
              exe = if mainProgram == null then pkg else "${pkg}/bin/${mainProgram}";
            in
            if printsResult == null then exe else writeIfChanged pkgs name exe printsResult
          );
        }
        // (lib.optionalAttrs (args != [ ] || printsResult != null) {
          options = lib.mkMerge (
            lib.optional (args != [ ]) (if args._type or null == "order" then args else lib.mkBefore args)
            # Separates options from files for the wrapper
            ++ lib.optional (printsResult != null) (lib.mkAfter [ "--" ])
          );
        })
        // (lib.optionalAttrs (stdinArgs != null) {
          stdin-options = if stdinArgs._type or null == "order" then stdinArgs else lib.mkBefore stdinArgs;
        })
        // (lib.optionalAttrs (cfg.includes != [ ]) {
          inherit (cfg) includes;
        })
        // (lib.optionalAttrs (cfg.excludes != [ ]) {
          inherit (cfg) excludes;
        })
        // (lib.optionalAttrs (cfg.priority != null) {
          inherit (cfg) priority;
        });
      };
    };

  all-modules =
    nixpkgs:
    [
      {
        _module.args = {
          pkgs = nixpkgs;
          lib = nixpkgs.lib;
        };
      }
      module-options
    ]
    ++ programs.modules;

  # treefmt-nix can be loaded into a submodule. In this case we get our `pkgs` from
  # our own standard option `pkgs`; not externally.
  submodule-modules = [
    (
      { config, lib, ... }:
      let
        inherit (lib)
          mkOption
          types
          ;
      in
      {
        options.pkgs = mkOption {
          type = types.uniq (types.lazyAttrsOf (types.raw or types.unspecified));
          description = ''
            Nixpkgs to use in `treefmt`.
          '';
        };
        config._module.args = {
          pkgs = config.pkgs;
        };
      }
    )
    module-options
  ]
  ++ programs.modules;

  # Use the Nix module system to validate the treefmt config file format.
  #
  # nixpkgs is an instance of <nixpkgs> that contains treefmt.
  # configuration is an attrset used to configure the nix module
  evalModule =
    nixpkgs: configuration:
    # NOTE: keep in sync with submoduleWith
    nixpkgs.lib.evalModules {
      modules = all-modules nixpkgs ++ [ configuration ];
      specialArgs = defaultSpecialArgs;
    };

  /**
    The built-in specialArgs for treefmt-nix.
    These are module arguments that are passed to all treefmt-nix modules.
  */
  defaultSpecialArgs = {
    inherit mkFormatterModule;
  };

  /**
    Invoke treefmt-nix as a submodule, integrating this into a larger configuration management system.

    Unlike in `evalModule`, the caller is responsible for setting `_module.args.pkgs` inside the submodule.

    # Inputs

    - `lib`: the Nixpkgs `lib`

    - attribute set
      - `modules`: additional modules to include. Unlike modules in `config`, these will be rendered in the documentation.
      - `specialArgs`: additional arguments to pass to all modules in the submodule. See [`evalModules`' `specialArgs`](https://nixos.org/manual/nixpkgs/stable/#module-system-lib-evalModules-param-specialArgs).

    # Output

    A module system type that can be passed to [`mkOption`](https://nixos.org/manual/nixos/stable/#sec-option-declarations)'s `type`.
  */
  submoduleWith =
    lib:
    {
      modules ? [ ],
      specialArgs ? { },
    }:
    # NOTE: keep in sync with evalModule
    lib.types.submoduleWith {
      modules = submodule-modules ++ modules;
      specialArgs = defaultSpecialArgs // specialArgs;
    };

  # Returns a treefmt.toml generated from the passed configuration.
  #
  # nixpkgs is an instance of <nixpkgs> that contains treefmt.
  # configuration is an attrset used to configure the nix module
  mkConfigFile =
    nixpkgs: configuration:
    let
      mod = evalModule nixpkgs configuration;
    in
    mod.config.build.configFile;

  # Returns an instance of treefmt, wrapped with some configuration.
  #
  # nixpkgs is an instance of <nixpkgs> that contains treefmt.
  # configuration is an attrset used to configure the nix module
  mkWrapper =
    nixpkgs: configuration:
    let
      mod = evalModule nixpkgs configuration;
    in
    mod.config.build.wrapper;
in
{
  inherit
    module-options
    programs
    all-modules
    submodule-modules
    evalModule
    submoduleWith
    mkConfigFile
    mkWrapper
    ;
}
