{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.programs.erlfmt;
in
{
  meta.maintainers = [ ];

  options.programs.erlfmt = {
    enable = lib.mkEnableOption "erlfmt";
    package = lib.mkPackageOption pkgs "erlfmt" { };
    print-width = lib.mkOption {
      description = "The line length that formatter would wrap on";
      type = lib.types.int;
      example = 80;
      default = 100;
    };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.erlfmt = {
      command = "${cfg.package}/bin/erlfmt";
      options = [
        "--print-width"
        (toString cfg.print-width)
        "--write"
      ];
      includes = [
        "*.erl"
        "*.hrl"
        "*.app"
        "*.app.src"
        "*.config"
        "*.script"
        "*.escript"
      ];
    };
  };
}
