{ lib, pkgs, config, ... }:
let
  cfg = config.programs.stylua;
in
{
  options.programs.stylua = {
    enable = lib.mkEnableOption "stylua";
    package = lib.mkPackageOption pkgs "stylua" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.stylua = {
      command = "${lib.getBin cfg.package}/bin/stylua";
      includes = [ "*.lua" ];
    };
  };
}
