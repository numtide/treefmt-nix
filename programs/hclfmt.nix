{ lib, pkgs, config, ... }:
let
  cfg = config.programs.hclfmt;
in
{
  options.programs.hclfmt = {
    enable = lib.mkEnableOption "hclfmt";
    package = lib.mkPackageOption pkgs "hclfmt" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.hclfmt = {
      command = cfg.package;
      options = [ "-w" ];
      includes = [ "*.tf" "*.hcl" ];
    };
  };
}
