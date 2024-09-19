{ lib, pkgs, config, ... }:
let
  cfg = config.programs.dart-format;
in
{
  meta.maintainers = [ "JakobLichterfeld" ];

  options.programs.dart-format = {
    enable = lib.mkEnableOption "dart-format";
    package = lib.mkPackageOption pkgs "dart" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.dart-format = {
      command = lib.getExe' cfg.package "dart";
      options = [ "format" ];
      includes = [ "*.dart" ];
    };
  };
}
