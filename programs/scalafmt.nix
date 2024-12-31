{ mkFormatterModule, ... }:
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "scalafmt";
      includes = [
        "*.sbt"
        "*.scala"
      ];
    })
  ];
}
