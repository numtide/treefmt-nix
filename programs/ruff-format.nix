{ lib, pkgs, config, ... }:
let
  cfg = config.programs.ruff-format;
in
{
  meta.maintainers = [ ];

  imports = [
    (lib.mkRenamedOptionModule [ "programs" "ruff" "format" ] [ "programs" "ruff-format" "enable" ])
  ];

  options.programs.ruff-format = {
    enable = lib.mkEnableOption "ruff formatter" // {
      description = ''
        Whether to enable the Ruff formatter, an extremely fast Python code formatter
        designed as a drop-in replacement for Black.
      '';
    };

    package = lib.mkPackageOption pkgs "ruff" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.ruff-format = lib.mkIf cfg.enable {
      command = cfg.package;
      options = lib.mkBefore [ "format" ];
      includes = [
        "*.py"
        "*.pyi"
      ];
    };
  };
}
