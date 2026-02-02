{ mkFormatterModule, ... }:
{
  meta.maintainers = [ "kpbaks" ];

  imports = [
    (mkFormatterModule {
      name = "tilt";
      package = "bazel-buildtools";
      mainProgram = "buildifier";
      includes = [
        "Tiltfile"
      ];
    })
  ];
}
