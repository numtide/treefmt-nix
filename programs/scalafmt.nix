{ lib, pkgs, config, ... }:
let
  cfg = config.programs.scalafmt;
in
{
  meta.maintainers = [ ];

  options.programs.scalafmt = {
    enable = lib.mkEnableOption "scalafmt";
    package = lib.mkPackageOption pkgs "scalafmt" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.scalafmt = {
      command = cfg.package;
      includes = [ "*.sbt" "*.scala" ];
    };
  };
}
