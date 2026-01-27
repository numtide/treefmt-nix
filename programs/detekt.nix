{
  lib,
  pkgs,
  config,
  mkFormatterModule,
  ...
}:
let
  cfg = config.programs.detekt;
in
{
  meta.maintainers = [
    "raphiz"
  ];

  imports = [
    (mkFormatterModule {
      name = "detekt";
      args = [
        "--auto-correct"
        "--parallel"
      ];
      includes = [
        "*.kt"
        "*.kts"
      ];
    })
  ];

  options.programs.detekt = {
    configFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "./detekt-config.yml";
      description = "Path to detekt configuration file";
    };

    buildUponDefaultConfig = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Preconfigures detekt with a bunch of rules and some opinionated defaults for you. Allows additional provided configurations to override the defaults.";
    };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.detekt = {
      options =
        lib.optional (cfg.buildUponDefaultConfig) "--build-upon-default-config"
        ++ lib.optional (cfg.configFile != null) "--config"
        ++ lib.optional (cfg.configFile != null) "${cfg.configFile}";

      command = pkgs.writeShellApplication {
        name = "detekt-wrapper";
        text = ''
          # To pass the files to detect, they must be comma separated as follows: `detekt --input "a,b,c"`
          # To build that string, we first skip all options passed to the wrapper and add them manually later.
          skipN="${toString (builtins.length config.settings.formatter.detekt.options)}"
          shift "$skipN"

          # Join file paths into detekt's `--input "a,b,c"` format.
          files=""
          for f in "$@"; do
            if [ -z "$files" ]; then
              files="$f"
            else
              files="$files,$f"
            fi
          done

          exec ${lib.getExe cfg.package} \
              ${lib.escapeShellArgs config.settings.formatter.detekt.options} \
              --input "$files"
        '';
      };
    };
  };
}
