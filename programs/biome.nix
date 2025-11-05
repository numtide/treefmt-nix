{
  lib,
  pkgs,
  config,
  mkFormatterModule,
  ...
}:
let
  l = lib // builtins;
  t = l.types;
  p = pkgs;
  json = p.formats.json { };

  cfg = config.programs.biome;
  biomeVersion = if builtins.match "^1\\." pkgs.biome.version != null then "1.9.4" else "2.1.2";
  schemaUrl = "https://biomejs.dev/schemas/${biomeVersion}/schema.json";
  schemaSha256s = {
    "1.9.4" = "sha256:0xia00hbazxnddinwx5bcfy3mrm8q31qgx78jcrj9q34nhn18jaa";
    "2.1.2" = "sha256:1d909q6abxc3kcaqx4b9ibkfgzpwds5l8cylans8gpz0kvl3b1lz";
  };
  schemaSha256 = schemaSha256s.${biomeVersion};

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
  meta.maintainers = [ "andrea11" ];

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
  };

  config = l.mkIf cfg.enable {
    settings.formatter.biome.options =
      let
        jsonFile = json.generate "biome.json" cfg.settings;
        biomeSchema = builtins.fetchurl {
          url = schemaUrl;
          sha256 = schemaSha256;
        };

        validatedConfig =
          p.runCommand "validated-biome-config.json"
            {
              buildInputs = [
                p.check-jsonschema
              ];
            }
            ''
              echo "Validating biome.json against schema ${schemaUrl}..."
              export HOME=$TMPDIR
              check-jsonschema --schemafile '${biomeSchema}' '${jsonFile}'
              cp '${jsonFile}' $out
            '';
      in
      [
        "--config-path"
        (l.toString validatedConfig)
      ]
      ++ l.optional cfg.formatUnsafe "--unsafe";
  };
}
