{ mkFormatterModule, ... }:
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "keep-sorted";
      includes = [ "*" ];
    })
  ];
}
