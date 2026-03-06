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
          Uses `${cfg.package}/share/schema.json` from the `programs.biome.package` output.
        '';
        default = "${cfg.package}/share/schema.json";
        example = l.literalExpression ''
          ${pkgs.biome}/share/schema.json
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
                schemaPath = toString cfg.validate.schema;
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
