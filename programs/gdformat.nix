{ lib, mkFormatterModule, ... }:
{
  meta.maintainers = [ ];
  # Broken on macOS
  meta.brokenPlatforms = lib.platforms.darwin;

  imports = [
    (mkFormatterModule {
      name = "gdformat";
      package = "gdtoolkit_4";
      mainProgram = "gdformat";
      includes = [ "*.gd" ];
    })
  ];
}
