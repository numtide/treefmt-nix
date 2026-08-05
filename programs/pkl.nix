{ mkFormatterModule, ... }:
{
  meta.maintainers = [ "tkoyasak" ];

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
