{ lib, pkgs, config, ... }:
let cfg = config.programs.csharpier;
in {
  options.programs.csharpier = {
    enable = lib.mkEnableOption "csharpier";
    package = lib.mkPackageOption pkgs "csharpier" { };
    dotnet-sdk = lib.mkPackageOption pkgs "dotnet-sdk" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.csharpier = {
      command = pkgs.writeShellApplication {
        name = "csharpier-fix";
        runtimeInputs = with cfg; [ dotnet-sdk package ];
        text = ''
          dotnet-csharpier "$@"
        '';
      };
      includes = [ "*.cs" ];
    };
  };
}
