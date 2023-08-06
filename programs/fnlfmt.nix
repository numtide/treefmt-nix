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
      command = "${lib.getBin cfg.package}/bin/fnlfmt";
      options = [ "--fix" ];
      includes = [ "*.fnl" ];
    };
  };
}
