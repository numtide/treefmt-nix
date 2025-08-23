{
  config,
  lib,
  mkFormatterModule,
  ...
}:
let
  cfg = config.programs.ruff-check;
in
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

  options.programs.ruff-check = {
    extendSelect = lib.mkOption {
      description = ''
        --extend-select options
      '';
      type = lib.types.listOf lib.types.str;
      example = [ "I" ];
      default = [ ];
    };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.ruff-check = {
      options = lib.optionals ((builtins.length cfg.extendSelect) != 0) [
        "--extend-select"
        (lib.concatStringsSep "," cfg.extendSelect)
      ];
    };
  };
}
