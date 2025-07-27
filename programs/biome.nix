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

  cfg = config.programs.biome;
  biomeVersion = if builtins.match "^1\\." pkgs.biome.version != null then "1.9.4" else "2.1.2";
  schemaUrl = "https://biomejs.dev/schemas/${biomeVersion}/schema.json";

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
      type = t.attrs;
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
        json = l.toJSON cfg.settings;
        jsonFile = p.writeText "biome.json" json;
        biomeSchema = builtins.fetchurl {
          url = schemaUrl;
          sha256 =
            # Support both nixpkgs and nixpkgs-unstable
            if biomeVersion == "1.9.4" then
              "sha256:0yzw4vymwpa7akyq45v7kkb9gp0szs6zfm525zx2vh1d80568dlz"
            else
              "sha256:07qlk53lja9rsa46b8nv3hqgdzc9mif5r1nwh7i8mrxcqmfp99s2";
        };

        validatedConfig =
          p.runCommand "validated-biome-config"
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
