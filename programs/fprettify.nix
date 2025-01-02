{ mkFormatterModule, ... }:
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "fprettify";
      includes = [ "*.f90" ];
    })
  ];
}
