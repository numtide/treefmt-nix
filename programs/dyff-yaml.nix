{ mkFormatterModule, ... }:
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "dyff-yaml";
      package = "dyff";
      args = [
        "yaml"
        "--restructure"
        "--in-place"
      ];
      includes = [
        "*.yaml"
        "*.yml"
      ];
    })
  ];
}
