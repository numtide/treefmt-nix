{
  lib,
  config,
  mkFormatterModule,
  ...
}:
let
  cfg = config.programs.formatjson5;
in
{
  meta.maintainers = [ "katexochen" ];

  imports = [
    (mkFormatterModule {
      name = "formatjson5";
      args = [ "--replace" ];
      includes = [ "*.json5" ];
    })
  ];

  options.programs.formatjson5 = {
    noTrailingCommas = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Suppress trailing commas (otherwise added by default)";
    };
    oneElementLines = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Objects or arrays with a single child should collapse to a single line";
    };
    sortArrays = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Sort arrays of primitive values (string, number, boolean, or null) lexicographically";
    };
    indent = lib.mkOption {
      type = lib.types.int;
      default = 4;
      description = "Indent by the given number of spaces";
    };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.formatjson5 = {
      options =
        [
          "--indent=${toString cfg.indent}"
        ]
        ++ lib.optional cfg.noTrailingCommas "--no_trailing_commas"
        ++ lib.optional cfg.oneElementLines "--one_element_lines"
        ++ lib.optional cfg.sortArrays "--sort_arrays";
    };
  };
}
