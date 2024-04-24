{ lib, pkgs, config, ... }:
let
  cfg = config.programs.ruff;
in
{
  options.programs.ruff = {
    enable = lib.mkEnableOption "ruff";
    package = lib.mkPackageOption pkgs "ruff" { };
    format = lib.mkEnableOption "ruff formatter" // {
      description = ''
        Whether to enable the Ruff formatter, an extremely fast Python code formatter
        designed as a drop-in replacement for Black.
      '';
    };
  };

  config = {
    settings.formatter = {
      ruff-check = lib.mkIf cfg.enable {
        command = cfg.package;
        options = [ "check" ];
        includes = [
          "*.py"
          "*.pyi"
        ];
      };
      ruff-format = lib.mkIf cfg.format {
        command = cfg.package;
        options = [ "format" ];
        includes = [
          "*.py"
          "*.pyi"
        ];
      };
    };
  };
}
