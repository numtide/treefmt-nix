{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.programs.csharpier;
  inherit (lib)
    mkEnableOption
    mkOption
    mkPackageOption
    mkIf
    types
    ;
in
{
  options.programs.csharpier = {
    enable = mkEnableOption "csharpier";
    package = mkPackageOption pkgs "csharpier" { };
    dotnet-sdk = mkPackageOption pkgs "dotnet-sdk" { };

    includes = mkOption {
      description = "Path / file patterns to include for CSharpier";
      type = types.listOf types.str;
      default = [ "*.cs" ];
    };

    excludes = mkOption {
      description = "Path / file patterns to exclude for CSharpier";
      type = types.listOf types.str;
      default = [ ];
    };
  };

  config = mkIf cfg.enable {
    settings.formatter.csharpier = {
      command = pkgs.writeShellApplication {
        name = "dotnet-csharpier";
        runtimeInputs = with cfg; [
          dotnet-sdk
          package
        ];
        text = ''
          dotnet-csharpier "$@"
        '';
      };
      includes = cfg.includes;
      excludes = cfg.excludes;
    };
  };
}
