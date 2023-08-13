{ lib, pkgs, config, ... }:
let
  inherit (lib) mkEnableOption mkOption mkPackageOption types;
  cfg = config.programs.buildifier;
in
{
  options.programs.buildifier = {
    enable = mkEnableOption "buildifier";
    package = mkPackageOption pkgs "buildifier" { };
    includes = mkOption {
      description = "Bazel file patterns to format";
      type = types.listOf types.str;
      default = [ "BUILD.bazel" "*.bzl" ];
    };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.buildifier = {
      command = "${cfg.package}/bin/buildifier";
      includes = cfg.includes;
    };
  };
}

