{ mkFormatterModule, ... }:
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "alejandra";
      includes = [ "*.nix" ];
    })
  ];
}
