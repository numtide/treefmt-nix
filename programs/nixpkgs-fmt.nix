{ mkFormatterModule, ... }:
{
  meta.maintainers = [ "zimbatm" ];

  imports = [
    (mkFormatterModule {
      name = "nixpkgs-fmt";
      includes = [ "*.nix" ];
    })
  ];
}
