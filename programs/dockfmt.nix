{ mkFormatterModule, ... }:
{
  meta.maintainers = [ "theobori" ];

  imports = [
    (mkFormatterModule {
      name = "dockfmt";
      args = [ "fmt" ];
      printsResult = "fromArgument";
      includes = [
        "Dockerfile"
        "*/Dockerfile"
        "*.Dockerfile"
        "Dockerfile.*"
        "*/Dockerfile.*"
        "*.dockerfile"
        "dockerfile.*"
        "*/dockerfile.*"
      ];
    })
  ];
}
