{ lib, pkgs, config, ... }:
let
  cfg = config.programs.terraform;
in
{
  options.programs.terraform = {
    enable = lib.mkEnableOption "terraform";
    package = lib.mkPackageOption pkgs "terraform" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.terraform = {
      command = "${lib.getBin cfg.package}/bin/terraform";
      options = [ "fmt" ];
      includes = [ "*.tf" ];
    };
  };
}
