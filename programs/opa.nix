{ lib, mkFormatterModule, ... }:
{
  meta.maintainers = [ ];
  meta.brokenPlatforms = lib.platforms.darwin;

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
