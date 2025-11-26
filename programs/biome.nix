{
  lib,
  pkgs,
  config,
  options,
  mkFormatterModule,
  ...
}:
let
  l = lib // builtins;
  t = l.types;
  p = pkgs;
  json = p.formats.json { };

  cfg = config.programs.biome;
  opts = options.programs.biome;
  biomeVersion =
    let
      v = pkgs.biome.version;
    in
    if builtins.match "^1\\." v != null then
      "1.9.4"
    else if builtins.match "^2\\.2\\." v != null then
      "2.2.5"
    else if builtins.match "^2\\.3\\." v != null then
      "2.3.5"
    else
      "2.1.2";
  schemaHashes = {
    "1.9.4" = "sha256-SkkULLRk4CQzk+j0h8PAqOY6vGOrdG5ja7Z/tSAAKnY=";
    "2.1.2" = "sha256-n4Y16J7g34e0VdQzRItu/P7n5oppkY4Vm4P1pQxOILU=";
    "2.2.5" = "sha256-no7jIazvyEp+hdwmuArQ/yRgnWrAw/NEM5qRInMRuaE=";
    "2.3.5" = "sha256-8O59CmHaP7/XuGs9BteOTcltddYSTxEIM/64dLfbLk0=";
  };

  ext.js = [
    "*.js"
    "*.ts"
    "*.mjs"
    "*.mts"
    "*.cjs"
    "*.cts"
    "*.jsx"
    "*.tsx"
    "*.d.ts"
    "*.d.cts"
    "*.d.mts"
  ];

  ext.json = [
    "*.json"
    "*.jsonc"
  ];

  ext.css = [
    "*.css"
  ];

in
{
  meta.maintainers = [
    "NixOS/nixpkgs-ci"
    "andrea11"
  ];

  imports = [
    (mkFormatterModule {
      name = "biome";
      args = [
        cfg.formatCommand
        "--write"
        "--no-errors-on-unmatched"
      ];
      includes = ext.js ++ ext.json ++ ext.css;
    })
  ];

  options.programs.biome = {
    formatCommand = l.mkOption {
      type = t.enum [
        "format"
        "lint"
        "check"
      ];
      description = "The command to run Biome with.";
      default = "check";
      example = "format";
    };
    formatUnsafe = l.mkOption {
      type = t.bool;
      description = "Allows to format a document that has unsafe fixes.";
      default = false;
    };
    configPath = l.mkOption {
      type = t.stringOrNull;
      description = "Path to a Biome configuration file.";
      default = null;
      example = "/path/to/biome.json";
    };
    settings = l.mkOption {
      inherit (json) type;
      description = "Raw Biome configuration (must conform to Biome JSON schema)";
      default = { };
      example = {
        formatter = {
          indentStyle = "space";
          lineWidth = 100;
        };
        javascript = {
          formatter = {
            quoteStyle = "single";
            lineWidth = 120;
          };
        };
        json = {
          formatter = {
            enabled = false;
          };
        };
      };
    };
    validate = {
      enable = l.mkOption {
        type = t.bool;
        description = "Whether to validate `${opts.settings}`.";
        default = true;
        example = false;
      };
      schema = l.mkOption {
        type = t.path;
        description = "The biome schema file to validate against";
        defaultText = l.literalMD ''
          Fetches `"https://biomejs.dev/schemas/''${biomeVersion}/schema.json"` using `pkgs.fetchurl`.
        '';
        default = p.fetchurl {
          url = "https://biomejs.dev/schemas/${biomeVersion}/schema.json";
          hash = schemaHashes.${biomeVersion};
        };
        example = l.literalExpression ''
          pkgs.fetchurl {
            url = "https://biomejs.dev/schemas/2.1.2/schema.json"
            hash = "sha256-n4Y16J7g34e0VdQzRItu/P7n5oppkY4Vm4P1pQxOILU=";
          }
        '';
      };
    };
  };

  config = l.mkIf cfg.enable {
    settings.formatter.biome.options =
      let
        jsonFile = json.generate "biome.json" cfg.settings;

        validatedConfig =
          p.runCommand "validated-biome-config.json"
            {
              nativeBuildInputs = [
                p.check-jsonschema
              ];
              env = {
                json = jsonFile;
                schema = cfg.validate.schema;
                schemaPath = cfg.validate.schema.url or (toString cfg.validate.schema);
              };
            }
            ''
              echo "Validating biome.json against schema $schemaPath..."
              export HOME=$TMPDIR
              check-jsonschema --schemafile "$schema" "$json"
              cp "$json" $out
            '';
      in
      [ ]
      ++ l.optional (cfg.configPath != null) [
        "--config-path"
        "${cfg.configPath}"
      ]
      ++ l.optional (cfg.configPath == null) [
        "--config-path"
        "${if cfg.validate.enable then validatedConfig else jsonFile}"
      ]
      ++ l.optional cfg.formatUnsafe "--unsafe";
  };
}
