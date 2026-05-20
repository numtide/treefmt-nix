{ mkFormatterModule, ... }:
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "pkl";
      args = [
        "format"
        "--write"
      ];
      includes = [
        "*.pkl"
        "PklProject"
      ];
    })
  ];
}
