{ mkFormatterModule, ... }:
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
}
