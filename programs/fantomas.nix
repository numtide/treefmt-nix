{ lib, pkgs, config, ... }:
let cfg = config.programs.fantomas;
in {
  meta.maintainers = [ ];

  options.programs.fantomas = {
    enable = lib.mkEnableOption "fantomas";
    package = lib.mkPackageOption pkgs "fantomas" { };
    dotnet-sdk = lib.mkPackageOption pkgs "dotnet-sdk" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.fantomas = {
      command = pkgs.writeShellApplication {
        name = "fantomas";
        runtimeInputs = with cfg; [ dotnet-sdk package ];
        text = ''
          fantomas "$@"
        '';
      };
      includes = [ "*.fs" "*.fsx" "*.fsi" "*.ml" "*.mli" ];
    };
  };
}
