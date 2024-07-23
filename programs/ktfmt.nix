{ lib, pkgs, config, ... }:
let
  cfg = config.programs.ktfmt;
in
{
  meta.maintainers = [ ];

  options.programs.ktfmt = {
    enable = lib.mkEnableOption "ktfmt";
    package = lib.mkPackageOption pkgs "ktfmt" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.ktfmt = {
      command = cfg.package;
      includes = [
        "*.kt"
        "*.kts"
      ];
    };
  };
}
