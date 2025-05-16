{ mkFormatterModule, ... }:
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "kdlfmt";
      args = [ "format" ];
      includes = [
        "*.kdl"
      ];
    })
  ];
}
