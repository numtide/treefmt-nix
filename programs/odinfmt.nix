{ mkFormatterModule, ... }:
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "odinfmt";
      package = "ols";
      mainProgram = "odinfmt";
      args = [ "-w" ];
      includes = [
        "*.odin"
      ];
    })
  ];
}
