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

  cfg = config.programs.biome;
in
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "biome";
      args = [
        "format"
        "--write"
        "--no-errors-on-unmatched"
      ];
      includes = ext.js ++ ext.json;
    })
  ];

  options.programs.biome = {
    settings =
      let
        shared = {
          indentStyle = l.mkOption {
            description = "The style of the indentation. It can be `tab` or `space`.";
            type = t.enum [
              "tab"
              "space"
            ];
            example = "space";
            default = "tab";
          };

          indentWidth = l.mkOption {
            description = "How big the indentation should be.";
            type = t.int;
            example = 4;
            default = 2;
          };

          lineEnding = l.mkOption {
            description = "The type of line ending.";
            type = t.enum [
              "lf"
              "crlf"
              "cr"
            ];
            example = "cr";
            default = "lf";
          };

          lineWidth = l.mkOption {
            description = "How many characters can be written on a single line.";
            type = t.int;
            example = 90;
            default = 80;
          };
        };

        common = {
          ignore = l.mkOption {
            description = "A list of Unix shell style patterns. Biome ignores files and folders that match these patterns.";
            type = t.listOf t.str;
            example = [ "scripts/*.js" ];
            default = [ ];
          };

          include = l.mkOption {
            description = ''
              A list of Unix shell style patterns. Biome handles only the files and folders that match these patterns.

              > [!Caution]
              > When both include and ignore are specified, ignore takes precedence over include
            '';
            type = t.listOf t.str;
            example = [ "scripts/*.js" ];
            default = [ ];
          };
        };
      in
      {
        formatter = {
          enabled = l.mkOption {
            description = "Enables Biome’s formatter";
            type = t.bool;
            example = false;
            default = true;
          };

          inherit (common) ignore include;

          formatWithErrors = l.mkOption {
            description = "Allows to format a document that has syntax errors.";
            type = t.bool;
            example = true;
            default = false;
          };
        } // shared;

        organizeImports = {
          enabled = l.mkOption {
            description = "Enables Biome’s sort imports.";
            type = t.bool;
            example = false;
            default = true;
          };

          inherit (common) ignore include;
        };

        javascript = {
          parser.unsafeParameterDecoratorsEnabled = l.mkOption {
            description = "Allows to support the unsafe/experimental parameter decorators.";
            type = t.bool;
            example = true;
            default = false;
          };

          formatter = {
            enabled = l.mkOption {
              description = "Enables Biome’s formatter for JavaScript (and its super languages) files.";
              type = t.bool;
              example = false;
              default = true;
            };

            quoteStyle = l.mkOption {
              description = "The type of quote used when representing string literals. It can be `single` or `double`.";
              type = t.enum [
                "single"
                "double"
              ];
              example = "single";
              default = "double";
            };

            jsxQuoteStyle = l.mkOption {
              description = "The type of quote used when representing jsx string literals. It can be `single` or `double`.";
              type = t.enum [
                "single"
                "double"
              ];
              example = "single";
              default = "double";
            };

            quoteProperties = l.mkOption {
              description = "When properties inside objects should be quoted. It can be `asNeeded` or `preserve`.";
              type = t.enum [
                "asNeeded"
                "preserve"
              ];
              example = "preserve";
              default = "asNeeded";
            };

            trailingComma = l.mkOption {
              description = ''
                Print trailing commas wherever possible in multi-line comma-separated syntactic structures. Possible values:

                - `all`, the trailing comma is always added
                - `es5`, the trailing comma is added only in places where it’s supported by older version of JavaScript
                - `none`, trailing commas are never added
              '';
              type = t.enum [
                "all"
                "es5"
                "none"
              ];
              example = "none";
              default = "all";
            };

            semicolons = l.mkOption {
              description = ''
                It configures where the formatter prints semicolons:

                - `always`, the semicolons is always added at the end of each statement;
                - `asNeeded`, the semicolons are added only in places where it’s needed, to protect from  [ASI](https://en.wikibooks.org/wiki/JavaScript/Automatic_semicolon_insertion)
              '';
              type = t.enum [
                "always"
                "asNeeded"
              ];
              example = "asNeeded";
              default = "always";
            };

            arrowParentheses = l.mkOption {
              description = ''
                Whether to add non-necessary parentheses to arrow functions:

                - `always`, the parentheses are always added;
                - `asNeeded`, the parentheses are added only when they are needed;
              '';
              type = t.enum [
                "always"
                "asNeeded"
              ];
              example = "asNeeded";
              default = "always";
            };

            bracketSameLine = l.mkOption {
              description = "Choose whether the ending `>` of a multi-line JSX element should be on the last attribute line or not";
              type = t.bool;
              example = true;
              default = false;
            };

            bracketSpacing = l.mkOption {
              description = "Choose whether spaces should be added between brackets and inner values";
              type = t.bool;
              example = false;
              default = true;
            };
          } // shared;

          globals = l.mkOption {
            description = "A list of global names that Biome should ignore";
            type = t.listOf t.str;
            example = [
              "$"
              "_"
              "externalVariable"
            ];
            default = [ ];
          };
        };

        json = {
          parser = {
            allowComments = l.mkOption {
              description = "Enables the parsing of comments in JSON files.";
              type = t.bool;
              example = false;
              default = true;
            };
            allowTrailingCommas = l.mkOption {
              description = "Enables the parsing of trailing Commas in JSON files.";
              type = t.bool;
              example = false;
              default = true;
            };
          };

          formatter = {
            enabled = l.mkOption {
              description = "Enables Biome’s formatter for JSON (and its super languages) files.";
              type = t.bool;
              example = false;
              default = true;
            };
          } // shared;
        };
      };
  };

  config = l.mkIf cfg.enable {
    settings.formatter.biome = {
      options =
        let
          settings =
            let
              # Modified to accumulate the path
              filterAttrsRecursive' =
                with l;
                pred: set: path:
                listToAttrs (
                  concatMap (
                    name:
                    let
                      v = set.${name};
                    in
                    if pred path name v then
                      [
                        (nameValuePair name (if isAttrs v then filterAttrsRecursive' pred v (path ++ [ name ]) else v))
                      ]
                    else
                      [ ]
                  ) (attrNames set)
                );

              # If an option retains its default value then it should be omitted to avoid unnecessarily creating a config path as long as the settings are not tampered with.
              filterDefaults =
                s:
                filterAttrsRecursive' (
                  path: n: v:
                  let
                    fullPath = path ++ [ n ];
                    setting =
                      l.attrByPath fullPath
                        (throw "treefmt: Unable to access options.programs.biome.settings.${l.concatStrings fullPath} during the defaults filter step.")
                        options.programs.biome.settings;
                  in
                  if l.isOption setting then setting.default != v else true
                ) s [ ];

              filterEmpty =
                s:
                l.filterAttrsRecursive (
                  _n: v: if l.isAttrs v then if v == { } then false else filterEmpty v != { } else true
                ) s;
            in
            filterEmpty (filterDefaults cfg.settings);
        in
        l.optionals (settings != { }) [
          # NOTE(@huwaireb): Biome does not accept a direct path to a file for config-path, only a directory.
          "--config-path"
          (l.toString (p.writeTextDir "biome.json" (l.toJSON settings)))
        ];
    };
  };
}
