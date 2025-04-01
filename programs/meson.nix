{
  config,
  lib,
  mkFormatterModule,
  ...
}:
let
  cfg = config.programs.meson;
in
{
  meta.maintainers = [ "RossSmyth" ];

  imports = [
    (mkFormatterModule {
      name = "meson";
      args = [
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
    })
  ];

  options.programs.meson = {
    editorconfig = lib.mkOption {
      description = ''
        Try to read configuration from .editorconfig
      '';
      type = lib.types.bool;
      example = true;
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.meson.options = lib.optionals cfg.editorconfig [ "-e" ];
  };
}
