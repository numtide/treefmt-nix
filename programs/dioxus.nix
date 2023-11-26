{ lib, pkgs, config, ... }:
let
  cfg = config.programs.dioxus;
in
  {
    options.programs.dioxus = {
      enable = lib.mkEnableOption "dioxus";
      package = lib.mkPackageOption pkgs "dioxus-cli" {};
    };

    config = lib.mkIf cfg.enable {
      settings.formatter.dioxus = {
        command = pkgs.writeShellApplication {
          name = "dioxus-fmt";
          runtimeInputs = [
            cfg.package
          ];
          text = ''
            set -x
            for file in "$@"; do
              echo "$file"
              dioxus fmt "$file"
            done
            set +x
          '';
        };
        includes = [ "*.rs" ];
      };
    };
  }
