{ lib, pkgs, config, ... }:
let
  cfg = config.programs.golangci-lint;
in
{
  options.programs.golangci-lint = {
    enable = lib.mkEnableOption "golangci-lint";
    package = lib.mkPackageOption pkgs "golangci-lint" { };
    goPackage = lib.mkPackageOption pkgs "go" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.golangci-lint = {
      command = pkgs.writeShellApplication {
        name = "golangci-lint";
        runtimeInputs = [
          cfg.package
          cfg.goPackage
        ];
        text = "${cfg.package}/bin/golangci-lint \"$@\"";
      };
      options = [ "run" ];
      includes = [ "*.go" ];
    };
  };
}
