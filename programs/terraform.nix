{ lib, pkgs, config, ... }:
let
  cfg = config.programs.terraform;
in
{
  meta.maintainers = [ ];

  options.programs.terraform = {
    enable = lib.mkEnableOption "terraform";
    # opentofu is the opensource version of terraform and cached in cache.nixos.org
    package = lib.mkPackageOption pkgs "opentofu" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.terraform = {
      command = cfg.package;
      options = [ "fmt" ];
      includes = [ "*.tf" ];
    };
  };
}
