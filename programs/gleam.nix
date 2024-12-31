{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.programs.gleam;
in
{
  meta.maintainers = [ "anntnzrb" ];

  options.programs.gleam = {
    enable = lib.mkEnableOption "gleam";
    package = lib.mkPackageOption pkgs "gleam" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.gleam = {
      command = cfg.package;
      options = [ "format" ];
      includes = [ "*.gleam" ];
    };
  };
}
