{ mkFormatterModule, ... }:
{
  meta.maintainers = [ "RossComputerGuy" ];

  imports = [
    (mkFormatterModule {
      name = "dtsfmt";
      package = "dtsfmt";
      includes = [ "*.dts" ];
    })
  ];
}
