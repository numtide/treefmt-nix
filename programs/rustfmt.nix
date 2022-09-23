{ lib, pkgs, config, ... }:
let
  cfg = config.programs.rustfmt;
in
{
  options.programs.rustfmt = {
    enable = lib.mkEnableOption "rustfmt";
    package = lib.mkPackageOption pkgs "rustc" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.rustfmt = {
      command = "${cfg.package}/bin/rustfmt";
      options = [ "--edition" "2018" ];
      includes = [ "*.rs" ];
    };
  };
}
