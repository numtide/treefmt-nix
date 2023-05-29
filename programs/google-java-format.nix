{ lib, pkgs, config, ... }:
let
  cfg = config.programs.google-java-format;
in
{
  options.programs.google-java-format = {
    enable = lib.mkEnableOption "google-java-format";
    package = lib.mkPackageOption pkgs "google-java-format" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.google-java-format = {
      command = cfg.package;
      options = [ "--replace" ];
      includes = [ "*.java" ];
    };
  };
}
