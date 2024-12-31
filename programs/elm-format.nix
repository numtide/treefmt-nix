{ mkFormatterModule, ... }:
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "elm-format";
      package = [
        "elmPackages"
        "elm-format"
      ];
      args = [ "--yes" ];
      includes = [ "*.elm" ];
    })
  ];
}
