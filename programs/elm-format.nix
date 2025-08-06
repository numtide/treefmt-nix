{ lib, mkFormatterModule, ... }:
{
  meta.maintainers = [ ];
  # See https://github.com/NixOS/nixpkgs/issues/370084
  meta.brokenPlatforms = lib.platforms.darwin;

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
