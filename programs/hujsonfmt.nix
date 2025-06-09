{ mkFormatterModule, ... }:
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "hujsonfmt";
      args = [ "-w" ];
      includes = [ "*.hujson" ];
    })
  ];
}
