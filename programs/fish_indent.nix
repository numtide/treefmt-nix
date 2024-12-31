{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.programs.fish_indent;
in
{
  meta.maintainers = [ ];

  options.programs.fish_indent = {
    enable = lib.mkEnableOption "fish_indent";
    package = lib.mkPackageOption pkgs "fish" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.fish_indent = {
      command = pkgs.writeShellApplication {
        name = "fish_indent-wrapper";
        runtimeInputs = [
          cfg.package
          pkgs.findutils
        ];
        text = ''
          fish_indent --check "$@" 2>&1 | xargs --no-run-if-empty fish_indent --write || true
        '';
      };
      includes = [ "*.fish" ];
    };
  };
}
