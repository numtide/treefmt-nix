{ mkFormatterModule, ... }:
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "cabal-fmt";
      package = [
        "haskellPackages"
        "cabal-fmt"
      ];
      args = [ "--inplace" ];
      includes = [ "*.cabal" ];
    })
  ];
}
