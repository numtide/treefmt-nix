{ lib, pkgs, config, ... }:
let
  cfg = config.programs.gofmt;
in
{
  options.programs.gofmt = {
    enable = lib.mkEnableOption "gofmt";
    package = lib.mkPackageOption pkgs "go" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.gofmt = {
      command = "${cfg.package}/bin/gofmt";
      options = [ "-w" ];
      includes = [ "*.go" ];
    };
  };
}
