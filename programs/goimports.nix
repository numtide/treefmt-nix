{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.programs.goimports;
in
{
  meta.maintainers = [ "gabyx" ];

  options.programs.goimports = {
    enable = lib.mkEnableOption "goimports";
    package = lib.mkPackageOption pkgs "gotools" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.goimports = {
      command = "${cfg.package}/bin/goimports";
      options = [ "-w" ];
      includes = [ "*.go" ];
      excludes = [ "vendor/*" ];
    };
  };
}
