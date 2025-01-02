{ mkFormatterModule, ... }:
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "opa";
      package = "open-policy-agent";
      args = [
        "fmt"
        "-w"
      ];
      includes = [ "*.rego" ];
    })
  ];
}
