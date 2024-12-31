{ mkFormatterModule, ... }:
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "nufmt";
      includes = [ "*.nu" ];
    })
  ];
}
