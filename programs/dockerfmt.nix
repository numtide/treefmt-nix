{ lib, mkFormatterModule, ... }:
{
  meta.maintainers = [ "bizmythy" ];
  meta.brokenPlatforms = lib.platforms.darwin;

  imports = [
    (mkFormatterModule {
      name = "dockerfmt";
      args = [
        "-w"
        "-n"
      ];
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
