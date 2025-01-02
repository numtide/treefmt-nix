{ mkFormatterModule, ... }:
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
}
