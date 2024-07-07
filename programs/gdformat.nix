{ lib, pkgs, config, ... }:
let
  cfg = config.programs.gdformat;
in
{
  options.programs.gdformat = {
    enable = lib.mkEnableOption "gdformat";
    package = lib.mkPackageOption pkgs "gdtoolkit_4" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.gdformat = {
      command = "${cfg.package}/bin/gdformat";
      includes = [ "*.gd" ];
    };
  };
}
