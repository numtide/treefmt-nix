{ lib, pkgs, config, ... }:
let
  cfg = config.programs.typstfmt;
in
{
  meta.maintainers = [ ];

  options.programs.typstfmt = {
    enable = lib.mkEnableOption "typstfmt";
    package = lib.mkPackageOption pkgs "typstfmt" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.typstfmt = {
      command = cfg.package;
      includes = [ "*.typ" "*.typst" ];
    };
  };
}
