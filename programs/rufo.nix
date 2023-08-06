{ lib, pkgs, config, ... }:
let
  cfg = config.programs.rufo;
in
{
  options.programs.rufo = {
    enable = lib.mkEnableOption "rufo";
    package = lib.mkPackageOption pkgs "rufo" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.rufo = {
      command = "${lib.getBin cfg.package}/bin/rufo";
      options = [ "-x" ];
      includes = [ "*.rb" ];
    };
  };
}
