{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.programs.rufo;
in
{
  meta.maintainers = [ ];

  options.programs.rufo = {
    enable = lib.mkEnableOption "rufo";
    package = lib.mkPackageOption pkgs "rufo" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.rufo = {
      command = cfg.package;
      options = [ "-x" ];
      includes = [ "*.rb" ];
    };
  };
}
