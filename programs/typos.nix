{ lib, pkgs, config, ... }:
let
  cfg = config.programs.typos;
in
{
  options.programs.typos = {
    enable = lib.mkEnableOption "typos";
    package = lib.mkPackageOption pkgs "typos" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.typos = {
      command = cfg.package;
      options = [ "-w" ];
      includes = [ "*" ];
    };
  };
}
