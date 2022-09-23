{ lib, pkgs, config, ... }:
let
  cfg = config.programs.shfmt;
in
{
  options.programs.shfmt = {
    enable = lib.mkEnableOption "shfmt";
    package = lib.mkPackageOption pkgs "shfmt" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.shfmt = {
      command = cfg.package;
      options = [ "-i" "2" "-s" "-w" ];
      includes = [ "*.sh" ];
    };
  };
}
