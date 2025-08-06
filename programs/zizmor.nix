{ lib, mkFormatterModule, ... }:
{
  meta.maintainers = [ "katexochen" ];
  meta.brokenPlatforms = lib.platforms.darwin;

  imports = [
    (mkFormatterModule {
      name = "zizmor";
      includes = [
        ".github/workflows/*.yml"
        ".github/workflows/*.yaml"
        ".github/actions/**/*.yml"
        ".github/actions/**/*.yaml"
      ];
    })
  ];
}
