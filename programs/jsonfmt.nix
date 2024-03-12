{ lib, pkgs, config, ... }:
let cfg = config.programs.jsonfmt;
in {
  options.programs.jsonfmt = {
    enable = lib.mkEnableOption "jsonfmt";
    package = lib.mkPackageOption pkgs "jsonfmt" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.jsonfmt = {
      command = cfg.package;
      includes = [ "*.json" ];
      options = [ "-w" ];
    };
  };
}
