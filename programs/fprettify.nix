{ lib, pkgs, config, ... }:
let
  cfg = config.programs.fprettify;
in
{
  options.programs.fprettify = {
    enable = lib.mkEnableOption "fprettify";
    package = lib.mkPackageOption pkgs "fprettify" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.fprettify = {
      command = "${cfg.package}/bin/fprettify";
      includes = [ "*.f90" ];
    };
  };
}
