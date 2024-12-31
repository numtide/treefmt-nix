{
  lib,
  config,
  mkFormatterModule,
  ...
}:
let
  cfg = config.programs.dhall;
in
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "dhall";
      includes = [ "*.dhall" ];
    })
  ];

  options.programs.dhall = {
    lint = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to lint in addition to formatting.";
    };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.dhall = {
      options = [ (if cfg.lint then "lint" else "format") ];
    };
  };
}
