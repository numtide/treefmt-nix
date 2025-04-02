{
  config,
  lib,
  mkFormatterModule,
  ...
}:
let
  cfg = config.programs.muon;
in
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "muon";
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

  options.programs.muon = {
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
    settings.formatter.muon.options = lib.optionals cfg.editorconfig [ "-e" ];
  };
}
