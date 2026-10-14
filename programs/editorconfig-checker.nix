{
  lib,
  config,
  mkFormatterModule,
  ...
}:
let
  cfg = config.programs.editorconfig-checker;
in
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "editorconfig-checker";
      package = "editorconfig-checker";
      includes = [ "*" ];
    })
  ];

  options.programs.editorconfig-checker = {
    configFile = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = ".editorconfig-checker.json";
      description = ''
        Path to the configuration file.
        By default, editorconfig-checker automatically detects `.editorconfig-checker.json` or `.ecrc` in the project root.
      '';
    };

    format = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "default"
          "gcc"
          "github-actions"
          "codeclimate"
        ]
      );
      default = null;
      example = "github-actions";
      description = "Output format (default, gcc, github-actions, codeclimate)";
    };

    disable-charset = lib.mkEnableOption "disabling the charset check";

    disable-end-of-line = lib.mkEnableOption "disabling the end-of-line check";

    disable-indentation = lib.mkEnableOption "disabling the indentation check";

    disable-indent-size = lib.mkEnableOption "disabling the indent-size check";

    disable-insert-final-newline = lib.mkEnableOption "disabling the final newline check";

    disable-max-line-length = lib.mkEnableOption "disabling the max-line-length check";

    disable-trim-trailing-whitespace = lib.mkEnableOption "disabling the trailing whitespace check";
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.editorconfig-checker.options =
      (lib.optionals (cfg.configFile != null) [
        "-config"
        cfg.configFile
      ])
      ++ (lib.optionals (cfg.format != null) [
        "-format"
        cfg.format
      ])
      ++ lib.optional cfg.disable-charset "-disable-charset"
      ++ lib.optional cfg.disable-end-of-line "-disable-end-of-line"
      ++ lib.optional cfg.disable-indentation "-disable-indentation"
      ++ lib.optional cfg.disable-indent-size "-disable-indent-size"
      ++ lib.optional cfg.disable-insert-final-newline "-disable-insert-final-newline"
      ++ lib.optional cfg.disable-max-line-length "-disable-max-line-length"
      ++ lib.optional cfg.disable-trim-trailing-whitespace "-disable-trim-trailing-whitespace";
  };
}
