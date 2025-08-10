{
  lib,
  pkgs,
  config,
  mkFormatterModule,
  ...
}:
let
  inherit (lib) mkOption types;

  cfg = config.programs.sizelint;
  configFormat = pkgs.formats.toml { };
  settingsSchema = mkOption {
    description = "Configuration to generate sizelint.toml with";
    default = { };
    type = types.submodule { freeformType = configFormat.type; };
  };
  settingsFile =
    if cfg.settings != { } then configFormat.generate "sizelint.toml" (cfg.settings) else null;
in
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "sizelint";
      args = [ "check" ];
      includes = [ "*" ];
    })
  ];

  options.programs.sizelint = {
    settings = settingsSchema;
    failOnWarn = lib.mkEnableOption "fail-on-warn";
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.sizelint = {
      options =
        lib.optionals (settingsFile != null) [
          "--config"
          (toString settingsFile)
        ]
        ++ lib.optional cfg.failOnWarn "--fail-on-warn";
    };
  };
}
