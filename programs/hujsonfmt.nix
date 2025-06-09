{ mkFormatterModule, ... }:
{
  meta.maintainers = [ "fjij" ];

  imports = [
    (mkFormatterModule {
      name = "hujsonfmt";
      args = [ "-w" ];
      includes = [ "*.hujson" ];
    })
  ];
}
