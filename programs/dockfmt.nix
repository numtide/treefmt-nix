{ mkFormatterModule, ... }:
{
  meta.maintainers = [ "theobori" ];

  imports = [
    (mkFormatterModule {
      name = "dockfmt";
      args = [
        "fmt"
        "-w"
      ];
      includes = [
        "Dockerfile"
        "*.Dockerfile"
        "Dockerfile.*"
      ];
    })
  ];
}
