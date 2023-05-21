{ lib, pkgs, config, ... }:
let
  cfg = config.programs.cspell;
in
{
  options.programs.cspell = {
    enable = lib.mkEnableOption "cspell";
    config = lib.mkOption {
      type = lib.types.str;
      default = "cspell.json";
      description = ''
        Path to the cspell configuration file.
      '';
    };
    includes = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "**" ];
    };
    package = lib.mkPackageOption pkgs.nodePackages "cspell" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.cspell = {
      command = pkgs.lib.meta.getExe cfg.package;
      options = [ "--no-progress" "--config" cfg.config ];
      includes = cfg.includes;
    };
  };
}
