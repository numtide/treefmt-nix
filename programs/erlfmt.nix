{
  lib,
  config,
  mkFormatterModule,
  ...
}:
let
  cfg = config.programs.erlfmt;
in
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "erlfmt";
      args = [ "--write" ];
      includes = [
        "*.erl"
        "*.hrl"
        "*.app"
        "*.app.src"
        "*.config"
        "*.script"
        "*.escript"
      ];
    })
  ];

  options.programs.erlfmt = {
    print-width = lib.mkOption {
      description = "The line length that formatter would wrap on";
      type = lib.types.int;
      example = 80;
      default = 100;
    };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.erlfmt = {
      options = [
        "--print-width"
        (toString cfg.print-width)
      ];
    };
  };
}
