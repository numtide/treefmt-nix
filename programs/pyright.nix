{
  lib,
  pkgs,
  config,
  ...
}:
let
  escapePath = lib.replaceStrings [ "/" "." ] [ "-" "" ];
in
{
  meta.maintainers = [ "otavio" ];
  # Example contains store paths
  meta.skipExample = true;

  options.programs.pyright = {
    enable = lib.mkEnableOption "pyright";
    package = lib.mkPackageOption pkgs "pyright" { };
    directories = lib.mkOption {
      description = ''
        Directories to run pyright in.

        Pyright auto-discovers `pyrightconfig.json` or `pyproject.toml`
        (`[tool.pyright]`) starting from the directory it is invoked in.
        Use `extraPaths` in that config to add module search paths —
        pyright does not read the `PYTHONPATH` environment variable.
      '';
      type = lib.types.attrsOf (
        lib.types.submodule (
          { name, ... }:
          {
            options = {
              directory = lib.mkOption {
                type = lib.types.str;
                default = name;
                description = ''
                  Directory to run pyright in, relative to the project root.
                  The empty string means the project root itself — no `cd`
                  is performed.
                '';
              };
              options = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                default = [ ];
                example = [ "--warnings" ];
                description = "Options to pass to pyright";
              };
              modules = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                default = [ "" ];
                example = [
                  "mymodule"
                  "tests"
                ];
                description = "Modules to check (passed as positional file/directory arguments)";
              };
            };
          }
        )
      );
      default = {
        "" = { };
      };
      example = {
        "" = {
          modules = [
            "mymodule"
            "tests"
          ];
        };
        "subdir" = { };
      };
    };
  };

  config = lib.mkIf config.programs.pyright.enable {
    settings.formatter = lib.mapAttrs' (
      name: cfg:
      let
        nonEmptyModules = lib.filter (m: m != "") cfg.modules;
        cdLine = lib.optionalString (cfg.directory != "") "cd ${lib.escapeShellArg cfg.directory}";
        args = lib.escapeShellArgs (cfg.options ++ nonEmptyModules);
      in
      lib.nameValuePair "pyright${lib.optionalString (name != "") "-${escapePath name}"}" {
        command = pkgs.bash;
        # Pyright resolves imports from a whole-module context, not per file,
        # so the wrapper ignores the file path treefmt passes as `$0` and always
        # invokes pyright on the configured `modules` (or the whole `directory`
        # when `modules` is empty). With treefmt's batch-size limit this means
        # pyright may be invoked more than once per directory on large file sets
        # — each call redundantly type-checks the same modules.
        #
        # `treefmt --stdin` is not supported: pyright type-checks the on-disk
        # modules regardless of what is piped in, so editor integrations should
        # use pyright's language server directly. A clean opt-out will become
        # possible once treefmt's Stdin Specification lands
        # (numtide/treefmt#586).
        options = [
          "-eucx"
          ''
            ${cdLine}
            exec ${lib.getExe config.programs.pyright.package} ${args}
          ''
        ];
        includes = lib.concatMap (
          module:
          let
            prefix = lib.optional (cfg.directory != "") cfg.directory ++ lib.optional (module != "") module;
          in
          [
            (lib.concatStringsSep "/" (prefix ++ [ "*.py" ]))
            (lib.concatStringsSep "/" (prefix ++ [ "*.pyi" ]))
          ]
        ) cfg.modules;
      }
    ) config.programs.pyright.directories;
  };
}
