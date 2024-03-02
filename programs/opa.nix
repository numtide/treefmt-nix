{ lib, pkgs, config, ... }:
let
  cfg = config.programs.opa;
in
{
  options.programs.opa = {
    enable = lib.mkEnableOption "opa";
    package = lib.mkPackageOption pkgs "open-policy-agent" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.opa = {
      command = cfg.package;
      options = [ "fmt" "-w" ];
      includes = [ "*.rego" ];
    };
  };
}
