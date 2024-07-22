{ lib, pkgs, config, ... }:
let
  cfg = config.programs.stylua;
in
{
  meta.maintainers = [ ];

  options.programs.stylua = {
    enable = lib.mkEnableOption "stylua";
    package = lib.mkPackageOption pkgs "stylua" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.stylua = {
      command = cfg.package;
      includes = [ "*.lua" ];
    };
  };
}
