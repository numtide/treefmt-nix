{ lib, pkgs, config, ... }:
let
  cfg = config.programs.dioxus-cli;
in
  {
    options.programs.dioxus-cli = {
      enable = lib.mkEnableOption "dioxus-cli";
      package = lib.mkPackageOption pkgs "dioxus-cli" {};
    };

    config = lib.mkIf cfg.enable {
      settings.formatter.dioxus-cli = {
        command = "${cfg.package}/bin/dioxus";
        options = [ "fmt" ];
        includes = [ ".rs" ];
      };
    };
  }
