{ mkFormatterModule, ... }:
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "nickel";
      args = [ "format" ];
      printsResult = "fromStdin";
      includes = [
        "*.ncl"
        "*.nickel"
      ];
    })
  ];
}
