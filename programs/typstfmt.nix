{ mkFormatterModule, ... }:
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "typstfmt";
      includes = [
        "*.typ"
        "*.typst"
      ];
    })
  ];
}
