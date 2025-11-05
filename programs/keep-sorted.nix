{ mkFormatterModule, ... }:
{
  meta.maintainers = [
    "NixOS/nixpkgs-ci"
    "katexochen"
  ];

  imports = [
    (mkFormatterModule {
      name = "keep-sorted";
      includes = [ "*" ];
    })
  ];
}
