{ lib, pkgs, config, ... }:
let
  cfg = config.programs.nixpkgs-fmt;
in
{
  meta.maintainers = [ "zimbatm" ];

  options.programs.nixpkgs-fmt = {
    enable = lib.mkEnableOption "nixpkgs-fmt";
    package = lib.mkPackageOption pkgs "nixpkgs-fmt" { };

    includes = lib.mkOption {
      description = "Path/file patterns to include for nixpkgs-fmt";
      type = lib.types.listOf lib.types.str;
      default = [ "*.nix" ];
    };
    excludes = lib.mkOption {
      description = "Path/file patterns to exclude for nixpkgs-fmt";
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.nixpkgs-fmt = {
      command = cfg.package;

      inherit (cfg)
        includes
        excludes;
    };
  };
}
