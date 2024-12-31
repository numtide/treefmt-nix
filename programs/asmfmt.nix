{ mkFormatterModule, ... }:
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "asmfmt";
      args = [ "-w" ];
      includes = [ "*.s" ];
    })
  ];
}
