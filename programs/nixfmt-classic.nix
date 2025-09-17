{ mkFormatterModule, ... }:
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "nixfmt-classic";
      includes = [ "*.nix" ];
    })
  ];
}
