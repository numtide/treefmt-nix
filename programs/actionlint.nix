{ mkFormatterModule, ... }:
{
  meta.maintainers = [ ];

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
