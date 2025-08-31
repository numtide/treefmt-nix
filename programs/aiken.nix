{ mkFormatterModule, ... }:
{
  meta.maintainers = [ "locallycompact" ];

  imports = [
    (mkFormatterModule {
      name = "aiken";
      args = [
        "fmt"
      ];
      includes = [ "*.ak" ];
    })
  ];
}
