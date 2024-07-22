{ lib, pkgs, config, ... }:
let
  cfg = config.programs.swift-format;
in
{
  meta.maintainers = [ ];

  options.programs.swift-format = {
    enable = lib.mkEnableOption "swift-format";
    package = lib.mkPackageOption pkgs "swift-format" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.swift-format = {
      command = cfg.package;
      options = [ "-i" ];
      includes = [ "*.swift" ];
    };
  };
}
