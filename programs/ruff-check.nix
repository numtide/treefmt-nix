{ lib, mkFormatterModule, ... }:
{
  meta.maintainers = [ ];

  imports = [
    (lib.mkRenamedOptionModule
      [ "programs" "ruff" "check" ]
      [
        "programs"
        "ruff-check"
        "enable"
      ]
    )
    (lib.mkRenamedOptionModule
      [ "programs" "ruff" "enable" ]
      [
        "programs"
        "ruff-check"
        "enable"
      ]
    )
    (mkFormatterModule {
      name = "ruff-check";
      package = "ruff";
      args = [
        "check"
        "--fix"
      ];
      includes = [
        "*.py"
        "*.pyi"
      ];
    })
  ];
}
