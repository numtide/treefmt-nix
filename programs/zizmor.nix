{ mkFormatterModule, ... }:
{
  meta.maintainers = [ "katexochen" ];

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
