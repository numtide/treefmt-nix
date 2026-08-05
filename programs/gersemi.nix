{
  lib,
  config,
  mkFormatterModule,
  ...
}:
let
  cfg = config.programs.gersemi;
in
{
  meta.maintainers = [ "vaisriv" ];

  imports = [
    (mkFormatterModule {
      name = "gersemi";
      args = [ "-i" ];
      includes = [
        "CMakeLists.txt"
        "CMakeLists.txt.in"
        "*.cmake"
        "*.cmake.in"
      ];
    })
  ];

  options.programs.gersemi = with lib; {
    indent = mkOption {
      type = types.nullOr (types.either (types.enum [ "tabs" ]) types.int);
      default = null;
      example = 2;
      description = ''
        Number of spaces used to indent or 'tabs' for indenting with tabs [default: 4]
      '';
    };
    lineLength = mkOption {
      type = types.nullOr types.int;
      default = null;
      example = 100;
      description = ''
        Maximum line length in characters. [default: 80]
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.gersemi.options =
      (lib.optionals (!isNull cfg.indent) [
        "--indent"
        (toString cfg.indent)
      ])
      ++ (lib.optionals (!isNull cfg.lineLength) [
        "--line-length"
        (toString cfg.lineLength)
      ]);
  };
}
