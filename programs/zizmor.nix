{ mkFormatterModule, ... }:
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "zizmor";
      includes = [
        ".github/workflows/*.yml"
        ".github/workflows/*.yaml"
      ];
    })
  ];
}
