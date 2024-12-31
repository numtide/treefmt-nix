# NOTE: this is the hclfmt that comes from hashicorp/hcl
{ mkFormatterModule, ... }:
{
  meta.maintainers = [ "zimbatm" ];

  imports = [
    (mkFormatterModule {
      name = "hclfmt";
      args = [ "-w" ];
      includes = [ "*.hcl" ];
    })
  ];
}
