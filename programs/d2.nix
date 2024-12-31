{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.programs.d2;
in
{
  options.programs.d2 = {
    enable = lib.mkEnableOption "d2";
    package = lib.mkPackageOption pkgs "d2" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.d2 = {
      command = "${cfg.package}/bin/d2";
      options = [ "fmt" ];
      includes = [ "*.d2" ];
    };
  };
}
