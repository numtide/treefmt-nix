{ mkFormatterModule, ... }:
{
  meta.maintainers = [
    "NixOS/nixpkgs-ci"
  ];

  imports = [
    (mkFormatterModule {
      name = "nixf-diagnose";
      includes = [ "*.nix" ];
    })
  ];
}
