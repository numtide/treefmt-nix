{ mkFormatterModule, ... }:
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "d2";
      args = [ "fmt" ];
      includes = [ "*.d2" ];
    })
  ];
}
