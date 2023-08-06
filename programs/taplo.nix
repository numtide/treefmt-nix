{ lib, pkgs, config, ... }:
let
  cfg = config.programs.taplo;
in
{
  options.programs.taplo = {
    enable = lib.mkEnableOption "taplo";
    package = lib.mkPackageOption pkgs "taplo" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.taplo = {
      command = "${lib.getBin cfg.package}/bin/taplo";
      options = [ "format" ];
      includes = [ "*.toml" ];
    };
  };
}
