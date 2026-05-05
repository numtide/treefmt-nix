{ lib, mkFormatterModule, ... }:
{
  meta.maintainers = [ "katexochen" ];
  meta.brokenPlatforms = lib.platforms.darwin;

  imports = [
    (mkFormatterModule {
      name = "actionlint";
      includes = [
        ".github/workflows/*.yml"
        ".github/workflows/*.yaml"
        ".gitea/workflows/*.yml"
        ".gitea/workflows/*.yaml"
        ".forgejo/workflows/*.yml"
        ".forgejo/workflows/*.yaml"
      ];
    })
  ];
}
