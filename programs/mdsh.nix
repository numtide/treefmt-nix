{ lib, pkgs, config, ... }:
let
  cfg = config.programs.mdsh;
in
{
  options.programs.mdsh = {
    enable = lib.mkEnableOption "mdsh";
    package = lib.mkPackageOption pkgs "mdsh" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.mdsh = {
      command = "${lib.getBin cfg.package}/bin/mdsh";
      options = [ "--inputs" ];
      includes = [ "README.md" ];
    };
  };
}
