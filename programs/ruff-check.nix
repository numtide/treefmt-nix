{ lib, pkgs, config, ... }:
let
  cfg = config.programs.ruff-check;
in
{
  meta.maintainers = [ ];

  imports = [
    (lib.mkRenamedOptionModule [ "programs" "ruff" "check" ] [ "programs" "ruff-check" "enable" ])
    (lib.mkRenamedOptionModule [ "programs" "ruff" "enable" ] [ "programs" "ruff-check" "enable" ])
  ];

  options.programs.ruff-check = {
    enable = lib.mkEnableOption "ruff linter" // {
      description = ''
        Whether to enable the Ruff linter, an extremely fast Python linter
        designed as a drop-in replacement for Flake8 (plus dozens of plugins),
        isort, pydocstyle, pyupgrade, autoflake, and more.
      '';
    };

    package = lib.mkPackageOption pkgs "ruff" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.ruff-check = {
      command = cfg.package;
      options = lib.mkBefore [ "check" "--fix" ];
      includes = [
        "*.py"
        "*.pyi"
      ];
    };
  };
}
