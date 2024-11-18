{ lib, pkgs, config, ... }:
let
  cfg = config.programs.typstyle;
  inherit (lib) mkEnableOption mkIf mkPackageOption;
in
{
  meta.maintainers = [ "SigmaSquadron" ];

  options.programs.typstyle = {
    enable = mkEnableOption "typstyle";
    package = mkPackageOption pkgs "typstyle" { };
  };

  config = mkIf cfg.enable {
    settings.formatter.typstyle = {
      command = cfg.package;
      options = [ "-i" ];
      includes = [ "*.typ" "*.typst" ];
    };
  };
}
