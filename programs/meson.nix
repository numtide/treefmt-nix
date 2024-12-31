{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.programs.meson;
in
{
  meta.maintainers = [ "RossSmyth" ];

  options.programs.meson = {
    enable = lib.mkEnableOption "meson";
    package = lib.mkPackageOption pkgs "meson" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.meson = {
      command = cfg.package;
      options = [
        "fmt"
        "-i"
      ];
      includes = [
        "meson.build"
        "meson.options"
        "meson_options.txt"
        "*/meson.build"
        "*/meson.options"
        "*/meson_options.txt"
      ];
    };
  };
}
