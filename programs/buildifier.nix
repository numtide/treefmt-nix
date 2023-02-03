{ lib, pkgs, config, ... }:
let
  cfg = config.programs.buildifier;
in
{
  options.programs.buildifier = {
    enable = lib.mkEnableOption "buildifier";
    package = lib.mkPackageOption pkgs "buildifier" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.buildifier = {
      command = "${cfg.package}/bin/buildifier";
      includes = [ "BUILD.bazel" "*.bzl" ];
    };
  };
}

