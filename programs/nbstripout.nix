{ mkFormatterModule, ... }:
{
  meta.maintainers = [ "BenZuckier" ];

  imports = [
    (mkFormatterModule {
      name = "nbstripout";
      includes = [ "*.ipynb" ];
    })
  ];

}
