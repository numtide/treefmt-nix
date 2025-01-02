{ mkFormatterModule, ... }:
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "jsonnetfmt";
      package = "go-jsonnet";
      mainProgram = "jsonnetfmt";
      args = [ "-i" ];
      includes = [
        "*.jsonnet"
        "*.libsonnet"
      ];
    })
  ];
}
