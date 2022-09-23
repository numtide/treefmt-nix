{ lib, pkgs, config, ... }:
let
  cfg = config.programs.gofumpt;
in
{
  options.programs.gofumpt = {
    enable = lib.mkEnableOption "gofumpt";
    package = lib.mkPackageOption pkgs "gofumpt" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.gofumpt = {
      command = cfg.package;
      options = [ "-w" ];
      includes = [ "*.go" ];
    };
  };
}
