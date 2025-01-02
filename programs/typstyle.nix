{ mkFormatterModule, ... }:
{
  meta.maintainers = [ "SigmaSquadron" ];

  imports = [
    (mkFormatterModule {
      name = "typstyle";
      args = [ "-i" ];
      includes = [
        "*.typ"
        "*.typst"
      ];
    })
  ];
}
