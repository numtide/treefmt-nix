{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.programs.jsonnetfmt;
in
{
  meta.maintainers = [ ];

  options.programs.jsonnetfmt = {
    enable = lib.mkEnableOption "jsonnet";
    package = lib.mkPackageOption pkgs "go-jsonnet" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.jsonnetfmt = {
      command = "${cfg.package}/bin/jsonnetfmt";
      options = [ "-i" ];
      includes = [
        "*.jsonnet"
        "*.libsonnet"
      ];
    };
  };
}
