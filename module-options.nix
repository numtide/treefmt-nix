{ config, lib, pkgs, ... }:
let
  inherit (lib) mkOption mkPackageOption types;

  # A new kind of option type that calls lib.getExe on derivations
  exeType = lib.mkOptionType {
    name = "exe";
    description = "Path to executable";
    check = (x: lib.isString x || builtins.isPath x || lib.isDerivation x);
    merge = loc: defs:
      let res = lib.mergeOneOption loc defs; in
      if lib.isString res || builtins.isPath res then
        "${res}"
      else
        lib.getExe res;
  };

  # The schema of the treefmt.toml data structure.
  configSchema = {
    excludes = mkOption {
      description = "A global list of paths to exclude. Supports glob.";
      type = types.listOf types.str;
      default = [ ];
      example = [ "./node_modules/**" ];
    };

    formatter = mkOption {
      type = types.attrsOf (types.submodule [{
        options = {
          command = mkOption {
            description = "Executable obeying the treefmt formatter spec";
            type = exeType;
          };

          options = mkOption {
            description = "List of arguments to pass to the command";
            type = types.listOf types.str;
            default = [ ];
          };

          includes = mkOption {
            description = "List of files to include for formatting. Supports globbing.";
            type = types.listOf types.str;
          };

          excludes = mkOption {
            description = "List of files to exclude for formatting. Supports globbing. Takes precedence over the includes.";
            type = types.listOf types.str;
            default = [ ];
          };
        };
      }]);
      default = { };
      description = "Set of formatters to use";
    };
  };

  configFormat = pkgs.formats.toml { };
in
{
  # Schema
  options = {
    # Represents the treefmt.toml config
    settings = configSchema;

    package = mkPackageOption pkgs "treefmt" { };

    projectRootFile = mkOption {
      description = ''
        File to look for to determine the root of the project in the
        build.wrapper.
      '';
      example = "flake.nix";
    };

    # Outputs
    build = {
      configFile = mkOption {
        description = ''
          Contains the generated config file derived from the settings.
        '';
        type = types.path;
      };
      wrapper = mkOption {
        description = ''
          The treefmt package, wrapped with the config file.
        '';
        type = types.package;
        defaultText = lib.literalMD "wrapped `treefmt` command";
        default =
          let
            x = pkgs.writeShellScriptBin config.package.name ''
              find_up() {
                ancestors=()
                while true; do
                  if [[ -f $1 ]]; then
                    echo "$PWD"
                    exit 0
                  fi
                  ancestors+=("$PWD")
                  if [[ $PWD == / ]] || [[ $PWD == // ]]; then
                    echo "ERROR: Unable to locate the projectRootFile ($1) in any of: ''${ancestors[*]@Q}" >&2
                    exit 1
                  fi
                  cd ..
                done
              }
              tree_root=$(find_up "${config.projectRootFile}")
              exec ${config.package}/bin/treefmt --config-file ${config.build.configFile} "$@" --tree-root "$tree_root"
            '';
          in
          (x // { meta = config.package.meta // x.meta; });
      };
      programs = mkOption {
        type = types.attrsOf types.package;
        description = ''
          Attrset of formatter programs enabled in treefmt configuration.

          The key of the attrset is the formatter name, with the value being the
          package used to do the formatting.
        '';
        defaultText = lib.literalMD "Programs used in configuration";
        default =
          pkgs.lib.concatMapAttrs
            (k: v:
              if v.enable
              then { "${k}" = v.package; }
              else { })
            config.programs;
      };
      check = mkOption {
        description = ''
          Create a flake check to test that the given project tree is already
          formatted.

          Input argument is the path to the project tree (usually 'self').
        '';
        type = types.functionTo types.package;
        defaultText = lib.literalMD "Default check implementation";
        default = self: pkgs.runCommandLocal "treefmt-check"
          {
            buildInputs = [ pkgs.git config.build.wrapper ];
          }
          ''
            set -e
            treefmt --version
            # `treefmt --fail-on-change` is broken for purs-tidy; So we must rely
            # on git to detect changes. An unintended advantage of this approach
            # is that when the check fails, it will print a helpful diff at the end.
            PRJ=$TMP/project
            cp -r ${self} $PRJ
            chmod -R a+w $PRJ
            cd $PRJ
            git init
            git config user.email "nix@localhost"
            git config user.name Nix
            git add .
            git commit -m init
            treefmt --no-cache
            git status
            git --no-pager diff --exit-code
            touch $out
          '';
      };
    };
  };

  # Config
  config.build = {
    configFile = configFormat.generate "treefmt.toml" config.settings;
  };
}
