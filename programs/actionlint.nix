{ mkFormatterModule, ... }:
{
  meta.maintainers = [ "katexochen" ];

  imports = [
    (mkFormatterModule {
      name = "actionlint";
      includes = [
        ".github/workflows/*.yml"
        ".github/workflows/*.yaml"
      ];
    })
  ];
}
