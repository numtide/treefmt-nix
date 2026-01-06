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
    if builtins.match "^1\\." pkgs.biome.version != null then
      "1.9.4"
    else if builtins.match "^2\\.3\\." pkgs.biome.version != null then
      "2.3.6"
    else
      "2.1.2";

  schemaHashes = {
    "1.9.4" = "sha256-SkkULLRk4CQzk+j0h8PAqOY6vGOrdG5ja7Z/tSAAKnY=";
    "2.1.2" = "sha256-n4Y16J7g34e0VdQzRItu/P7n5oppkY4Vm4P1pQxOILU=";
    "2.3.6" = "sha256-eBBUomh9qBkl47tp73vsgWeOPZdVVGR3CAQ5eBs8eNw=";
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
      [
        "--config-path"
        "${if cfg.validate.enable then validatedConfig else jsonFile}"
      ]
      ++ l.optional cfg.formatUnsafe "--unsafe";
  };
}
