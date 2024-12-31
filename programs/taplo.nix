{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.programs.taplo;
in
{
  meta.maintainers = [ ];

  options.programs.taplo = {
    enable = lib.mkEnableOption "taplo";
    package = lib.mkPackageOption pkgs "taplo" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.taplo = {
      command = cfg.package;
      options = [ "format" ];
      includes = [ "*.toml" ];
    };
  };
}
