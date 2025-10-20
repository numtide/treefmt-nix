{ mkFormatterModule, ... }:
{
  imports = [
    (mkFormatterModule {
      name = "dscanner";
      args = [ "lint" ];
      includes = [
        "*.d"
      ];
    })
  ];
}
