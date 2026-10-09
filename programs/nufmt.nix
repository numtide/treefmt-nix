{
  lib,
  config,
  mkFormatterModule,
  ...
}:
let
  cfg = config.programs.nufmt;
in
{
  meta.maintainers = [
    "gabyx"
  ];

  imports = [
    (mkFormatterModule {
      name = "nufmt";
      package = "nufmt";
      includes = [ "*.nu" ];
    })
  ];

  options.programs.nufmt = {
    configFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      description = "Path to the `nufmt` config file (if needed).";
      default = null;
    };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.nufmt.options = lib.optionals (!isNull cfg.configFile) [
      "--config"
      "${cfg.configFile}"
    ];
  };
}
