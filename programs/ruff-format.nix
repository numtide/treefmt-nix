{ lib, mkFormatterModule, ... }:
{
  meta.maintainers = [ ];

  imports = [
    (lib.mkRenamedOptionModule
      [ "programs" "ruff" "format" ]
      [
        "programs"
        "ruff-format"
        "enable"
      ]
    )
    (mkFormatterModule {
      name = "ruff-format";
      package = "ruff";
      args = [ "format" ];
      includes = [
        "*.py"
        "*.pyi"
      ];
    })
  ];
}
