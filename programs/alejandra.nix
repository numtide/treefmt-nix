{ lib, pkgs, config, ... }:
let
  cfg = config.programs.alejandra;
in
{
  meta.maintainers = [ ];

  options.programs.alejandra = {
    enable = lib.mkEnableOption "alejandra";
    package = lib.mkPackageOption pkgs "alejandra" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.alejandra = {
      command = cfg.package;
      includes = [ "*.nix" ];
    };
  };
}
