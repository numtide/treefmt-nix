{
  lib,
  pkgs,
  config,
  mkFormatterModule,
  ...
}:
let
  cfg = config.programs.fantomas;
in
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "fantomas";
      includes = [
        "*.fs"
        "*.fsx"
        "*.fsi"
        "*.ml"
        "*.mli"
      ];
    })
  ];

  options.programs.fantomas = {
    dotnet-sdk = lib.mkPackageOption pkgs "dotnet-sdk" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.fantomas = {
      command = pkgs.writeShellApplication {
        name = "fantomas";
        runtimeInputs = with cfg; [
          dotnet-sdk
          package
        ];
        text = ''
          fantomas "$@"
        '';
      };
    };
  };
}
