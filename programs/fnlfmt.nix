{ lib, pkgs, config, ... }:
let
  cfg = config.programs.fnlfmt;
in
{
  options.programs.fnlfmt = {
    enable = lib.mkEnableOption "fnlfmt";
    package = lib.mkPackageOption pkgs "fnlfmt" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.fnlfmt = {
      command = cfg.package;
      options = [ "--fix" ];
      includes = [ "*.fnl" ];
    };
  };
}
