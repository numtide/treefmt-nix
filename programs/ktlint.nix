{ mkFormatterModule, ... }:
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "ktlint";
      args = [ "--format" ];
      includes = [
        "*.kt"
        "*.kts"
      ];
    })
  ];
}
