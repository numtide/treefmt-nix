{ lib, pkgs, config, ... }:
let
  cfg = config.programs.scalafmt;
in
{
  options.programs.scalafmt = {
    enable = lib.mkEnableOption "scalafmt";
    package = lib.mkPackageOption pkgs "scalafmt" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.scalafmt = {
      command = "${lib.getBin cfg.package}/bin/scalafmt";
      includes = [ "*.sbt" "*.scala" ];
    };
  };
}
