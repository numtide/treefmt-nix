{ lib, pkgs, config, ... }:
let
  cfg = config.programs.yamlfmt;
in
{
  options.programs.yamlfmt = {
    enable = lib.mkEnableOption "yamlfmt";
    package = lib.mkPackageOption pkgs "yamlfmt" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.yamlfmt = {
      command = cfg.package;
      includes = [ "*.yaml" ];
    };
  };
}
