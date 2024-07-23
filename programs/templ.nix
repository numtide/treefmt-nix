{ lib, pkgs, config, ... }:
let
  cfg = config.programs.templ;
in
{
  meta.maintainers = [ ];

  options.programs.templ = {
    enable = lib.mkEnableOption "templ";
    package = lib.mkPackageOption pkgs "templ" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.templ = {
      command = "${cfg.package}/bin/templ";
      options = [ "fmt" ];
      includes = [ "*.templ" ];
    };
  };
}
