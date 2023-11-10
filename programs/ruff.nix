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

  config = lib.mkIf cfg.enable {
    settings.formatter.ruff = {
      command = cfg.package;
      options = lib.optional cfg.format "format";
      includes = [ "*.py" ];
    };
  };
}
