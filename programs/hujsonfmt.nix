{ mkFormatterModule, ... }:
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "hujsonfmt";
      options = [ "-w" ];
      includes = [ "*.hujson" ];
    })
  ];
}
