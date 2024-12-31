{
  lib,
  pkgs,
  config,
  mkFormatterModule,
  ...
}:
let
  cfg = config.programs.csharpier;
in
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "csharpier";
      includes = [ "*.cs" ];
    })
  ];

  options.programs.csharpier = {
    dotnet-sdk = lib.mkPackageOption pkgs "dotnet-sdk" { };
  };

  config = lib.mkIf cfg.enable {
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
    };
  };
}
