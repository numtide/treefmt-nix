{ lib, pkgs, config, ... }:
let
  cfg = config.programs.actionlint;
in
{
  options.programs.actionlint = {
    enable = lib.mkEnableOption "actionlint";
    package = lib.mkPackageOption pkgs "actionlint" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.actionlint = {
      command = cfg.package;
      includes = [
        ".github/workflows/*.yml"
        ".github/workflows/*.yaml"
      ];
    };
  };
}
