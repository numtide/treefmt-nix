{ lib, pkgs, config, ... }:
let
  cfg = config.programs.asmfmt;
in
{
  options.programs.asmfmt = {
    enable = lib.mkEnableOption "asmfmt";
    package = lib.mkPackageOption pkgs "asmfmt" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.asmfmt = {
      command = "${cfg.package}/bin/asmfmt";
      options = [ "-w" ];
      includes = [ "*.s" ];
    };
  };
}
