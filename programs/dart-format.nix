{ lib, pkgs, config, ... }:
let
  cfg = config.programs.dart;
in
{
  meta.maintainers = [ "JakobLichterfeld" ];

  options.programs.dart = {
    enable = lib.mkEnableOption "dart-format";
    package = lib.mkPackageOption pkgs "dart" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.dart = {
      command = cfg.package;
      options = [ "format" ];
      includes = [ "*.dart" ];
    };
  };
}
