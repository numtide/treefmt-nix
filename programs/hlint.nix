{ mkFormatterModule, ... }:
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "hlint";
      args = [ "-j" ];
      includes = [ "*.hs" ];
    })
  ];
}
