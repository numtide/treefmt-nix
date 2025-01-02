{ mkFormatterModule, ... }:
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "templ";
      args = [ "fmt" ];
      includes = [ "*.templ" ];
    })
  ];
}
