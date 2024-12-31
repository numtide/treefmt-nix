{ mkFormatterModule, ... }:
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "nixfmt";
      package = "nixfmt-rfc-style";
      includes = [ "*.nix" ];
    })
  ];
}
