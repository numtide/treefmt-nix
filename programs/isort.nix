{ lib, pkgs, config, ... }:
let
  cfg = config.programs.isort;
in
{
  options.programs.isort = {
    enable = lib.mkEnableOption "isort";
    package = lib.mkPackageOption pkgs "isort" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.isort = {
      command = cfg.package;
      options = [ ];
      includes = [ "*.py" ];
    };
  };
}
