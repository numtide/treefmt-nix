{ lib, pkgs, config, ... }:
let
  cfg = config.programs.nixfmt;
in
{
  options.programs.nixfmt = {
    enable = lib.mkEnableOption "nixfmt";
    package = lib.mkPackageOption pkgs "nixfmt" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.nixfmt = {
      command = "${lib.getBin cfg.package}/bin/nixfmt";
      includes = [ "*.nix" ];
    };
  };
}
