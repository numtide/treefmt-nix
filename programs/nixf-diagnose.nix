{ mkFormatterModule, ... }:
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "nixf-diagnose";
      includes = [ "*.nix" ];
    })
  ];
}
