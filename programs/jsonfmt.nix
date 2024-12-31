{ mkFormatterModule, ... }:
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "jsonfmt";
      args = [ "-w" ];
      includes = [ "*.json" ];
    })
  ];
}
