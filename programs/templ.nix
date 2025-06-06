{
  config,
  lib,
  mkFormatterModule,
  pkgs,
  ...
}:
let
  cfg = config.programs.templ;
in
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "templ";
      args = [ "fmt" ];
      includes = [ "*.templ" ];
    })
  ];

  config = lib.mkIf cfg.enable {
    settings.formatter.templ = {
      command = pkgs.writeShellApplication {
        name = "templ";
        runtimeInputs = [
          pkgs.go
          pkgs.templ
        ];
        text = ''
          exec templ "$@"
        '';
      };
    };
  };
}
