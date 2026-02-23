{ mkFormatterModule, ... }:
{
  meta.maintainers = [ "kpbaks" ];

  imports = [
    (mkFormatterModule {
      name = "grafana-alloy";
      package = "grafana-alloy";
      mainProgram = "alloy";
      args = [
        "fmt"
        "--write"
      ];
      includes = [
        "*.alloy"
      ];
    })
  ];
}
