{ lib, pkgs, config, ... }:
let
  cfg = config.programs.ruff;
in
{
  meta.maintainers = [ ];

  options.programs.ruff = {
    package = lib.mkPackageOption pkgs "ruff" { };
    check = lib.mkEnableOption "ruff linter" // {
      description = ''
        Whether to enable the Ruff linter, an extremely fast Python linter
        designed as a drop-in replacement for Flake8 (plus dozens of plugins),
        isort, pydocstyle, pyupgrade, autoflake, and more.
      '';
    };
    format = lib.mkEnableOption "ruff formatter" // {
      description = ''
        Whether to enable the Ruff formatter, an extremely fast Python code formatter
        designed as a drop-in replacement for Black.
      '';
    };
  };

  config = {
    settings.formatter = {
      ruff-check = lib.mkIf cfg.check {
        command = cfg.package;
        options = lib.mkBefore [ "check" "--fix" ];
        includes = [
          "*.py"
          "*.pyi"
        ];
      };
      ruff-format = lib.mkIf cfg.format {
        command = cfg.package;
        options = lib.mkBefore [ "format" ];
        includes = [
          "*.py"
          "*.pyi"
        ];
      };
    };
  };
}
