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
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "nufmt";
      package = "nufmt";
      includes = [ "*.nu" ];
    })
  ];

  options.programs.nufmt = {
    config = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Path to the nufmt configuration file (nufmt.nuon).
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.nufmt.options = lib.optionals (cfg.config != null) [
      "--config"
      (toString cfg.config)
    ];
  };
}
