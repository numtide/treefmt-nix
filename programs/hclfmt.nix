# NOTE: this is the hclfmt that comes from hashicorp/hcl
{ lib, pkgs, config, ... }:
let
  cfg = config.programs.hclfmt;
in
{
  meta.maintainers = [ "zimbatm" ];

  options.programs.hclfmt = {
    enable = lib.mkEnableOption "hclfmt";
    package = lib.mkPackageOption pkgs "hclfmt" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.hclfmt = {
      command = cfg.package;
      options = [
        "-w" # write in place
      ];
      includes = [
        "*.hcl"
      ];
    };
  };
}
