{
  lib,
  config,
  mkFormatterModule,
  ...
}:
let
  cfg = config.programs.goimports;
in
{
  meta.maintainers = [ "gabyx" ];

  imports = [
    (mkFormatterModule {
      name = "goimports";
      package = "gotools";
      args = [ "-w" ];
      includes = [ "*.go" ];
      excludes = [ "vendor/*" ];
    })
  ];

  config = lib.mkIf cfg.enable {
    settings.formatter.goimports = {
      command = "${cfg.package}/bin/goimports";
    };
  };
}
