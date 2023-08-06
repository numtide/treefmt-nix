{ lib, pkgs, config, ... }:
let
  cfg = config.programs.nixpkgs-fmt;
in
{
  options.programs.nixpkgs-fmt = {
    enable = lib.mkEnableOption "nixpkgs-fmt";
    package = lib.mkPackageOption pkgs "nixpkgs-fmt" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.nixpkgs-fmt = {
      command = "${lib.getBin cfg.package}/bin/nixpkgs-fmt";
      includes = [ "*.nix" ];
    };
  };
}
