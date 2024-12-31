{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.programs.nickel;
in
{
  meta.maintainers = [ ];

  options.programs.nickel = {
    enable = lib.mkEnableOption "nickel";
    package = lib.mkPackageOption pkgs "nickel" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.nickel = {
      command = cfg.package;
      options = [ "format" ];
      includes = [
        "*.ncl"
        "*.nickel"
      ];
    };
  };
}
