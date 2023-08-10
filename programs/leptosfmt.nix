{ lib, pkgs, config, ... }:
let
  cfg = config.programs.leptosfmt;
in
{
  options.programs.leptosfmt = {
    enable = lib.mkEnableOption "leptosfmt";
    package = lib.mkPackageOption pkgs "leptosfmt" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.leptosfmt = {
      command = pkgs.writeShellApplication {
        name = "leptosfmt-forall";
        runtimeInputs = [ cfg.package ];
        text = ''
          for file in "$@"; do
            leptosfmt "$file"
          done
        '';
      };
      includes = [ "*.rs" ];
    };
  };
}
