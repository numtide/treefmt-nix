{ lib, pkgs, config, ... }:
let
  cfg = config.programs.shellcheck;
in
{
  options.programs.shellcheck = {
    enable = lib.mkEnableOption "shellcheck";
    package = lib.mkPackageOption pkgs "shellcheck" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.shellcheck = {
      command = "${lib.getBin cfg.package}/bin/shellcheck";
      includes = [ "*.sh" ];
    };
  };
}
