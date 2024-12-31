{
  lib,
  pkgs,
  config,
  mkFormatterModule,
  ...
}:
let
  inherit (lib)
    filterAttrsRecursive
    mkIf
    mkOption
    optionals
    types
    ;

  cfg = config.programs.dprint;
  configFormat = pkgs.formats.json { };

  # Definition taken from:
  # https://raw.githubusercontent.com/dprint/dprint/5168db9ff0a9b5d42774f95edd58681fc67c9009/website/src/assets/schemas/v0.json
  settingsSchema = mkOption {
    default = { };
    description = "Configuration to generate dprint.json with";
    type = types.submodule {
      freeformType = configFormat.type;
      options = {
        incremental = mkOption {
          description = "Whether to format files only when they change.";
          type = types.nullOr types.bool;
          example = true;
          default = null;
        };
        extends = mkOption {
          description = "Configurations to extend.";
          type = types.nullOr (
            types.oneOf [
              types.str
              (types.listOf types.str)
            ]
          );
          example = "https://dprint.dev/path/to/config/file.v1.json";
          default = null;
        };
        lineWidth = mkOption {
          description = ''
            The width of a line the printer will try to stay under. Note that the
            printer may exceed this width in certain cases.
          '';
          type = types.nullOr types.int;
          example = 80;
          default = null;
        };
        indentWidth = mkOption {
          description = "The number of characters for an indent";
          type = types.nullOr types.int;
          example = 2;
          default = null;
        };
        useTabs = mkOption {
          description = ''
            Whether to use tabs (true) or spaces (false) for indentation.
          '';
          type = types.nullOr types.bool;
          example = true;
          default = null;
        };
        newLineKind = mkOption {
          description = ''
            The kind of newline to use (one of: auto, crlf, lf, system).
          '';
          type = types.nullOr types.str;
          example = "auto";
          default = null;
        };
        includes = mkOption {
          internal = true;
          description = "Set this value on program.dprint.includes";
          type = types.nullOr (types.listOf types.str);
          default = null;
        };
        excludes = mkOption {
          internal = true;
          description = "Set this value on program.dprint.excludes";
          type = types.nullOr (types.listOf types.str);
          default = null;
        };
        plugins = mkOption {
          description = "Array of plugin URLs to format files.";
          type = types.nullOr (types.listOf types.str);
          example = [
            "https://plugins.dprint.dev/json-0.17.2.wasm"
            "https://plugins.dprint.dev/markdown-0.15.2.wasm"
            "https://plugins.dprint.dev/typescript-0.84.4.wasm"
          ];
          default = null;
        };
      };
    };
  };

  settingsFile =
    let
      # remove all null values
      settings = filterAttrsRecursive (_n: v: v != null) cfg.settings;
    in
    if settings != { } then
      configFormat.generate "dprint.json" (
        settings
        // {
          includes = cfg.includes;
          excludes = cfg.excludes;
        }
      )
    else
      null;
in
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "dprint";
      args = [ "fmt" ];
      includes = [ ".*" ];
    })
  ];

  options.programs.dprint = {
    # Represents the dprint.json config schema
    settings = settingsSchema;
  };

  config = mkIf cfg.enable {
    settings.formatter.dprint = {
      options = optionals (settingsFile != null) [
        "--config"
        (toString settingsFile)
      ];
    };
  };
}
