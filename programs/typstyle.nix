{
  lib,
  config,
  mkFormatterModule,
  ...
}:
let
  cfg = config.programs.typstyle;
in
{
  meta.maintainers = [ "SigmaSquadron" ];

  imports = [
    (mkFormatterModule {
      name = "typstyle";
      args = [ "-i" ];
      includes = [
        "*.typ"
        "*.typst"
      ];
    })
  ];

  options.programs.typstyle = with lib; {
    indentWidth = mkOption {
      type = types.nullOr types.int;
      default = null;
      example = 4;
      description = ''
        Number of spaces per indent level (default: 2).
      '';
    };
    lineWidth = mkOption {
      type = types.nullOr types.int;
      default = null;
      example = 100;
      description = ''
        Maximum line width in characters (default: 80).
      '';
    };
    wrapText = mkEnableOption "line wrapping of markup text";
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.typstyle.options =
      lib.optional cfg.wrapText "--wrap-text"
      ++ lib.optionals (!isNull cfg.lineWidth) [
        "--line-width"
        (toString cfg.lineWidth)
      ]
      ++ lib.optionals (!isNull cfg.indentWidth) [
        "--indent-width"
        (toString cfg.indentWidth)
      ];
  };

}
