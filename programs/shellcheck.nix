{ lib, pkgs, config, ... }:
let
  cfg = config.programs.shellcheck;
in
{
  meta.maintainers = [ "zimbatm" ];

  options.programs.shellcheck = {
    enable = lib.mkEnableOption "shellcheck";
    package = lib.mkPackageOption pkgs "shellcheck" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.shellcheck = {
      command = cfg.package;
      includes = [
        "*.sh"
        "*.bash"
        # direnv
        "*.envrc"
      ];
    };
  };
}
