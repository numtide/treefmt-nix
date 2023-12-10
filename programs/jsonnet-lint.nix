{ lib, pkgs, config, ... }:
let
  cfg = config.programs.jsonnet-lint;
in
{
  options.programs.jsonnet-lint = {
    enable = lib.mkEnableOption "jsonnet";
    package = lib.mkPackageOption pkgs "go-jsonnet" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.jsonnet-lint = {
      command = "${cfg.package}/bin/jsonnet-lint";
      includes = [ "*.jsonnet" "*.libsonnet" ];
    };
  };
}
