{
  lib,
  pkgs,
  config,
  mkFormatterModule,
  ...
}:
let
  inherit (lib) filterAttrsRecursive mkOption types;

  cfg = config.programs.prettier;
  configFormat = pkgs.formats.json { };

  # Configuration schema for Prettier, which we generate prettierrc.json with.
  # Definition taken from: http://json.schemastore.org/prettierrc
  settingsSchema = {
    arrowParens = mkOption {
      description = "Include parentheses around a sole arrow function parameter.";
      type = types.nullOr (
        types.enum [
          "always"
          "avoid"
        ]
      );
      example = "always";
      default = null;
    };
    bracketSameLine = mkOption {
      description = ''
        Put > of opening tags on the last line instead of on a new line.
      '';
      type = types.nullOr types.bool;
      example = false;
      default = null;
    };
    bracketSpacing = mkOption {
      description = "Print spaces between brackets";
      type = types.nullOr types.bool;
      example = true;
      default = null;
    };
    cursorOffset = mkOption {
      description = ''
        Print (to stderr) where a cursor at the given position would move to
        after formatting. This option cannot be used with --range-start and
        --range-end.
      '';
      type = types.nullOr types.int;
      example = -1;
      default = null;
    };
    editorconfig = mkOption {
      description = ''
        Whether parse the .editorconfig file in your project and convert its
        properties to the corresponding Prettier configuration. This
        configuration will be overridden by .prettierrc, etc.
      '';
      type = types.nullOr types.bool;
      example = false;
      default = null;
    };
    embeddedLanguageFormatting = mkOption {
      description = ''
        Control how Prettier formats quoted code embedded in the file.
      '';
      type = types.nullOr (
        types.enum [
          "auto"
          "off"
        ]
      );
      example = "auto";
      default = null;
    };
    endOfLine = mkOption {
      description = "Which end of line characters to apply.";
      type = types.nullOr (
        types.enum [
          "lf"
          "crlf"
          "cr"
          "auto"
        ]
      );
      example = "lf";
      default = null;
    };
    filepath = mkOption {
      description = ''
        Specify the input filepath. This will be used to do parser inference.
      '';
      type = types.nullOr types.str;
      example = "example.js";
      default = null;
    };
    htmlWhitespaceSensitivity = mkOption {
      description = "How to handle whitespaces in HTML.";
      type = types.nullOr (
        types.enum [
          "css"
          "strict"
          "ignore"
        ]
      );
      example = "css";
      default = null;
    };
    insertPragma = mkOption {
      description = ''
        Insert @format pragma into file's first docblock commentypes.
      '';
      type = types.nullOr types.bool;
      example = false;
      default = null;
    };
    jsxSingleQuote = mkOption {
      description = "Use single quotes in JSX";
      type = types.nullOr types.bool;
      example = false;
      default = null;
    };
    parser = mkOption {
      description = "Which parser to use.";
      type = types.nullOr (
        types.either (types.enum [
          "flow"
          "babel"
          "babel-flow"
          "babel-ts"
          "typescript"
          "acorn"
          "espree"
          "meriyah"
          "css"
          "less"
          "scss"
          "json"
          "json5"
          "json-stringify"
          "graphql"
          "markdown"
          "mdx"
          "vue"
          "yaml"
          "glimmer"
          "html"
          "angular"
          "lwc"
        ]) types.str
      );
      example = "typescript";
      default = null;
    };
    pluginSearchDirs = mkOption {
      description = ''
        Custom directory that contains prettier plugins in node_modules
        subdirectory. Overrides default behavior when plugins are searched
        relatively to the location of Prettier.\nMultiple values are accepted.
      '';
      type = types.nullOr (types.either (types.listOf types.str) (types.enum [ false ]));
      example = false;
      default = null;
    };
    plugins = mkOption {
      description = ''
        Add a plugin. Multiple plugins can be passed as separate `--plugin`s.
      '';
      type = types.nullOr (types.listOf types.str);
      example = [ "@prettier/plugin-xml" ];
      default = null;
    };
    printWidth = mkOption {
      description = "The line length where Prettier will try wrap.";
      type = types.nullOr types.int;
      example = 80;
      default = null;
    };
    proseWrap = mkOption {
      description = "How to wrap prose.";
      type = types.nullOr (
        types.enum [
          "always"
          "never"
          "preserve"
        ]
      );
      example = "preserve";
      default = null;
    };
    quoteProps = mkOption {
      description = "Change when properties in objects are quoted";
      type = types.nullOr (
        types.enum [
          "as-needed"
          "consistent"
          "preserve"
        ]
      );
      example = "as-needed";
      default = null;
    };
    rangeEnd = mkOption {
      description = ''
        Format code ending at a given character offset (exclusive). The range
        will extend forwards to the end of the selected statementypes. This
        option cannot be used with --cursor-offsetypes.
      '';
      type = types.nullOr types.str;
      example = 0;
      default = null;
    };
    rangeStart = mkOption {
      description = ''
        Format code starting at a given character offsetypes. The range will
        extend backwards to the start of the first line containing the selected
        statementypes. his option cannot be used with --cursor-offsetypes.
      '';
      type = types.nullOr types.int;
      example = 0;
      default = null;
    };
    requirePragma = mkOption {
      description = ''
        Require either '@prettier' or '@format' to be present in the file's
        first docblock comment\nin order for it to be formatted.
      '';
      type = types.nullOr types.bool;
      example = false;
      default = null;
    };
    semi = mkOption {
      description = "Print semicolons.";
      type = types.nullOr types.bool;
      example = false;
      default = null;
    };
    singleAttributePerLine = mkOption {
      description = "Enforce single attribute per line in HTML, Vue and JSX.";
      type = types.nullOr types.bool;
      example = false;
      default = null;
    };
    singleQuote = mkOption {
      description = "Use single quotes instead of double quotes.";
      type = types.nullOr types.bool;
      example = false;
      default = null;
    };
    tabWidth = mkOption {
      description = "Number of spaces per indentation level.";
      type = types.nullOr types.int;
      example = 2;
      default = null;
    };
    trailingComma = mkOption {
      description = "Print trailing commas wherever possible when multi-line.";
      type = types.nullOr (
        types.enum [
          "es5"
          "none"
          "all"
        ]
      );
      example = "es5";
      default = null;
    };
    useTabs = mkOption {
      description = "Indent with tabs instead of spaces";
      type = types.nullOr types.bool;
      example = false;
      default = null;
    };
    vueIndentScriptAndStyle = mkOption {
      description = "Indent script and style tags in Vue files.";
      type = types.nullOr types.bool;
      example = false;
      default = null;
    };
    overrides = mkOption {
      description = ''
        Provide a list of patterns to override prettier configuration.
      '';
      type = types.nullOr (types.listOf types.attrs);
      example = {
        files = [
          "*.html"
          "legacy/**/*.js"
        ];
        options.tabwidth = 4;
      };
      default = null;
    };
  };

  settingsFile =
    let
      # remove all null values
      settings = filterAttrsRecursive (_n: v: v != null) cfg.settings;
    in
    if settings != { } then configFormat.generate "prettierrc.json" settings else null;
in
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "prettier";
      package = [
        "nodePackages"
        "prettier"
      ];
      args = [ "--write" ];
      includes = [
        "*.cjs"
        "*.css"
        "*.html"
        "*.js"
        "*.json"
        "*.json5"
        "*.jsx"
        "*.md"
        "*.mdx"
        "*.mjs"
        "*.scss"
        "*.ts"
        "*.tsx"
        "*.vue"
        "*.yaml"
        "*.yml"
      ];
    })
  ];

  options.programs.prettier = {
    # Represents the prettierrc.json config schema
    settings = settingsSchema;
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.prettier = {
      options = lib.optionals (settingsFile != null) [
        "--config"
        (toString settingsFile)
      ];
    };
  };
}
