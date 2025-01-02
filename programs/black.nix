{ mkFormatterModule, ... }:
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "black";
      includes = [
        "*.py"
        "*.pyi"
      ];
    })
  ];
}
