# NOTE: this is the hclfmt that comes from hashicorp/hcl
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
      command = "${lib.getBin cfg.package}/bin/hclfmt";
      options = [
        "-w" # write in place
      ];
      includes = [
        "*.hcl"
        "*.tf"
        # TODO: any other file extensions?
      ];
    };
  };
}
