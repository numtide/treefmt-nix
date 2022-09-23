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
      command = cfg.package;
      options = [ "fmt" ];
      includes = [ "*.tf" ];
    };
  };
}
