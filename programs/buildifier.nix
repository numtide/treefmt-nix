{ mkFormatterModule, ... }:
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "buildifier";
      mainProgram = "buildifier";
      includes = [
        "*.bazel"
        "*.bzl"
      ];
    })
  ];
}
