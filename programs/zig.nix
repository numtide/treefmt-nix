{ lib, mkFormatterModule, ... }:
{
  meta.maintainers = [ ];
  # Broken on macOS
  meta.brokenPlatforms = lib.platforms.darwin;

  imports = [
    (mkFormatterModule {
      name = "zig";
      package = "zig";
      args = [ "fmt" ];
      includes = [
        "*.zig"
        "*.zon"
      ];
    })
  ];
}
