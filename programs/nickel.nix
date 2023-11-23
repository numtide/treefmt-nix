{ lib, pkgs, config, ... }:
let
  cfg = config.programs.nickel;

  wrapper = pkgs.writeShellScriptBin "nickelfmt" ''
    set -euo pipefail

    for file in "$@"; do
      ${cfg.package}/bin/nickel format "$file"
    done
  '';
in
{
  options.programs.nickel = {
    enable = lib.mkEnableOption "nickel";
    package = lib.mkPackageOption pkgs "nickel" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.nickel = {
      command = wrapper // { meta = config.package.meta // wrapper.meta; };
      includes = [ "*.ncl" "*.nickel" ];
    };
  };
}
