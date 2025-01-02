{ mkFormatterModule, ... }:
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "ktfmt";
      includes = [
        "*.kt"
        "*.kts"
      ];
    })
  ];
}
