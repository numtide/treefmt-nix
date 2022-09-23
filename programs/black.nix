{ lib, pkgs, config, ... }:
let
  cfg = config.programs.black;
in
{
  options.programs.black = {
    enable = lib.mkEnableOption "black";
    package = lib.mkPackageOption pkgs "black" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.black = {
      command = cfg.package;
      includes = [ "*.py" ];
    };
  };
}
