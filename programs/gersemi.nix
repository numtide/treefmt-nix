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
    indentWidth = mkOption {
      type = types.nullOr types.int;
      default = null;
      example = 2;
      description = ''
        Number of spaces used for indentation [default: 4].
        Cannot be set when `tabIndent` is enabled.
      '';
    };
    tabIndent = mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = ''
        Use tabs for indentation instead of spaces.
        Cannot be enabled when `indentWidth` is specified.
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
      lib.optionals (!isNull cfg.lineLength) [
        "--line-length"
        (toString cfg.lineLength)
      ]
      ++ (
        if cfg.tabIndent then
          if !isNull cfg.indentWidth then
            throw "programs.gersemi: `tabIndent` and `indentWidth` are mutually exclusive."
          else
            [
              "--indent"
              "tabs"
            ]
        else
          lib.optionals (!isNull cfg.indentWidth) [
            "--indent"
            (toString cfg.indentWidth)
          ]
      );
  };
}
