{ lib, pkgs, config, ... }:
let
  cfg = config.programs.dos2unix;
in
{
  options.programs.dos2unix = {
    enable = lib.mkEnableOption "dos2unix";
    package = lib.mkPackageOption pkgs "dos2unix" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.dos2unix = {
      command = "${cfg.package}/bin/dos2unix";
      options = [ "--keepdate" ];
      includes = [ "*" ];
    };
  };
}
