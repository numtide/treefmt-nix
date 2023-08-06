{ lib, pkgs, config, ... }:
let
  cfg = config.programs.ruff;
in
{
  options.programs.ruff = {
    enable = lib.mkEnableOption "ruff";
    package = lib.mkPackageOption pkgs "ruff" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.ruff = {
      command = "${lib.getBin cfg.package}/bin/ruff";
      includes = [ "*.py" ];
    };
  };
}
