{ lib, pkgs, config, ... }:
let
  cfg = config.programs.ktlint;
in
{
  meta.maintainers = [ ];

  options.programs.ktlint = {
    enable = lib.mkEnableOption "ktlint";
    package = lib.mkPackageOption pkgs "ktlint" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.ktlint = {
      command = cfg.package;
      options = [ "--format" ];
      includes = [
        "*.kt"
        "*.kts"
      ];
    };
  };
}
