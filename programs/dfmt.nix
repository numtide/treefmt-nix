{ mkFormatterModule, ... }:
{
  imports = [
    (mkFormatterModule {
      name = "dfmt";
      package = "dformat";
      args = [ "-i" ];
      includes = [
        "*.d"
      ];
    })
  ];
}
