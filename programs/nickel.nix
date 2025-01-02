{ mkFormatterModule, ... }:
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "nickel";
      args = [ "format" ];
      includes = [
        "*.ncl"
        "*.nickel"
      ];
    })
  ];
}
