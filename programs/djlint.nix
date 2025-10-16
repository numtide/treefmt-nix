{
  lib,
  config,
  mkFormatterModule,
  ...
}:
let
  cfg = config.programs.djlint;
in
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "djlint";
      includes = [ "*.html" ];
    })
  ];

  options.programs.djlint = {
    lint = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to lint in addition to formatting.";
    };
    ignoreRules = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Which H-rules to ignore";
    };
    indent = lib.mkOption {
      type = lib.types.ints.unsigned;
      default = 4;
      description = "Default indentation depth in spaces";
    };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.djlint = {
      options = [
        "--reformat"
        "--quiet"
        "--indent"
        (builtins.toString cfg.indent)
      ]
      ++ lib.optional cfg.lint "--lint"
      ++ lib.optional (cfg.ignoreRules != [ ]) ("--ignore=" + lib.concatStringsSep "," cfg.ignoreRules);
    };
  };
}
