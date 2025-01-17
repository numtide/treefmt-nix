{ mkFormatterModule, ... }:
{
  meta.maintainers = [ "katexochen" ];

  imports = [
    (mkFormatterModule {
      name = "keep-sorted";
      includes = [ "*" ];
    })
  ];
}
