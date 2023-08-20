{ lib, pkgs, config, ... }:
let
  cfg = config.programs.dhall;
in
{
  options.programs.dhall = {
    enable = lib.mkEnableOption "Dhall";
    lint = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = lib.mdDoc "Whether to lint in addition to formatting.";
    };
    package = lib.mkPackageOption pkgs "Dhall" { default = [ "dhall" ]; };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.dhall = {
      command = cfg.package;
      options = [ (if cfg.lint then "lint" else "format") ];
      includes = [ "*.dhall" ];
    };
  };
}
