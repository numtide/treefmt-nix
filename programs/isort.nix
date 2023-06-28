{ lib, pkgs, config, ... }:
let
  cfg = config.programs.isort;
in
{
  options.programs.isort = {
    enable = lib.mkEnableOption "isort";
    package = lib.mkPackageOption pkgs "isort" { };
    profile = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = ''
        The profile to use for isort.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.isort = {
      command = cfg.package;
      options = if cfg.profile != "" then [ "--profile" cfg.profile ] else [ ];
      includes = [ "*.py" ];
    };
  };
}
