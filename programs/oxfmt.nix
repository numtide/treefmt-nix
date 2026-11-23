{
  lib,
  pkgs,
  config,
  mkFormatterModule,
  ...
}:
let
  inherit (lib)
    filterAttrs
    mkOption
    optionals
    types
    ;

  cfg = config.programs.oxfmt;
  configFormat = pkgs.formats.json { };

  importSelectorType = types.enum [
    "type"
    "side_effect_style"
    "side_effect"
    "style"
    "index"
    "sibling"
    "parent"
    "subpath"
    "internal"
    "builtin"
    "external"
    "import"
  ];

  importModifierType = types.enum [
    "side_effect"
    "type"
    "value"
    "default"
    "wildcard"
    "named"
  ];

  newlinesBetweenMarkerType = types.submodule {
    options = {
      newlinesBetween = mkOption {
        description = ''
          Override `sortImports.newlinesBetween` for a group boundary marker.
        '';
        type = types.bool;
        example = true;
      };
    };
  };

  customGroupItemType = types.submodule {
    options = {
      elementNamePattern = mkOption {
        description = "Glob patterns to match import sources for this custom group.";
        type = types.nullOr (types.listOf types.str);
        example = [ "@app/**" ];
        default = null;
      };
      groupName = mkOption {
        description = "Name of the custom group.";
        type = types.nullOr types.str;
        example = "internal";
        default = null;
      };
      modifiers = mkOption {
        description = "Import modifiers that must match this custom group.";
        type = types.nullOr (types.listOf importModifierType);
        example = [ "type" ];
        default = null;
      };
      selector = mkOption {
        description = "Import selector that must match this custom group.";
        type = types.nullOr importSelectorType;
        example = "internal";
        default = null;
      };
    };
  };

  sortGroupItemType = types.oneOf [
    newlinesBetweenMarkerType
    types.str
    (types.listOf types.str)
  ];

  sortImportsConfigType = types.submodule {
    options = {
      customGroups = mkOption {
        description = "Custom import groups used by `sortImports`.";
        type = types.nullOr (types.listOf customGroupItemType);
        default = null;
      };
      groups = mkOption {
        description = ''
          Ordered import groups for `sortImports`.
          Entries can be a group name, grouped names, or a `{ newlinesBetween = ...; }` marker.
        '';
        type = types.nullOr (types.listOf sortGroupItemType);
        example = [
          "builtin"
          "external"
          [
            "internal"
            "subpath"
          ]
          {
            newlinesBetween = true;
          }
          [
            "parent"
            "sibling"
            "index"
          ]
        ];
        default = null;
      };
      ignoreCase = mkOption {
        description = "Whether sorting is case-sensitive.";
        type = types.nullOr types.bool;
        example = true;
        default = null;
      };
      internalPattern = mkOption {
        description = "Prefixes used to detect internal imports.";
        type = types.nullOr (types.listOf types.str);
        example = [
          "~/"
          "@/"
        ];
        default = null;
      };
      newlinesBetween = mkOption {
        description = "Whether to insert newlines between import groups.";
        type = types.nullOr types.bool;
        example = true;
        default = null;
      };
      order = mkOption {
        description = "Sort order for imports.";
        type = types.nullOr (
          types.enum [
            "asc"
            "desc"
          ]
        );
        example = "asc";
        default = null;
      };
      partitionByComment = mkOption {
        description = "Treat comments as import partition boundaries.";
        type = types.nullOr types.bool;
        example = false;
        default = null;
      };
      partitionByNewline = mkOption {
        description = "Treat empty lines as import partition boundaries.";
        type = types.nullOr types.bool;
        example = false;
        default = null;
      };
      sortSideEffects = mkOption {
        description = "Whether side-effect imports are sorted.";
        type = types.nullOr types.bool;
        example = false;
        default = null;
      };
    };
  };

  sortPackageJsonConfigType = types.submodule {
    options = {
      sortScripts = mkOption {
        description = "Whether to sort `package.json` scripts alphabetically.";
        type = types.nullOr types.bool;
        example = true;
        default = null;
      };
    };
  };

  sortTailwindcssConfigType = types.submodule {
    options = {
      attributes = mkOption {
        description = "Additional attribute names to sort for Tailwind classes.";
        type = types.nullOr (types.listOf types.str);
        example = [
          "class"
          ":class"
        ];
        default = null;
      };
      config = mkOption {
        description = "Path to a Tailwind CSS v3 config file.";
        type = types.nullOr types.str;
        example = "./tailwind.config.js";
        default = null;
      };
      functions = mkOption {
        description = "Function names whose class-string arguments should be sorted.";
        type = types.nullOr (types.listOf types.str);
        example = [
          "clsx"
          "cn"
          "cva"
        ];
        default = null;
      };
      preserveDuplicates = mkOption {
        description = "Whether to preserve duplicate Tailwind classes.";
        type = types.nullOr types.bool;
        example = false;
        default = null;
      };
      preserveWhitespace = mkOption {
        description = "Whether to preserve whitespace around Tailwind classes.";
        type = types.nullOr types.bool;
        example = false;
        default = null;
      };
      stylesheet = mkOption {
        description = "Path to a Tailwind CSS v4 stylesheet.";
        type = types.nullOr types.str;
        example = "./src/theme.css";
        default = null;
      };
    };
  };

  formatOptions = {
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
      description = "Put `>` of opening tags on the last line instead of a new line.";
      type = types.nullOr types.bool;
      example = false;
      default = null;
    };
    bracketSpacing = mkOption {
      description = "Print spaces between brackets in object literals.";
      type = types.nullOr types.bool;
      example = true;
      default = null;
    };
    embeddedLanguageFormatting = mkOption {
      description = "Control formatting for embedded language sections.";
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
      description = "Which end-of-line sequence to apply.";
      type = types.nullOr (
        types.enum [
          "lf"
          "crlf"
          "cr"
        ]
      );
      example = "lf";
      default = null;
    };
    htmlWhitespaceSensitivity = mkOption {
      description = "How whitespace in HTML is handled.";
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
    insertFinalNewline = mkOption {
      description = "Whether to insert a trailing newline at end-of-file.";
      type = types.nullOr types.bool;
      example = true;
      default = null;
    };
    jsxSingleQuote = mkOption {
      description = "Use single quotes in JSX.";
      type = types.nullOr types.bool;
      example = false;
      default = null;
    };
    objectWrap = mkOption {
      description = "How object literals are wrapped.";
      type = types.nullOr (
        types.enum [
          "preserve"
          "collapse"
        ]
      );
      example = "preserve";
      default = null;
    };
    printWidth = mkOption {
      description = "Line length where Oxfmt will try wrapping.";
      type = types.nullOr types.int;
      example = 100;
      default = null;
    };
    proseWrap = mkOption {
      description = "How to wrap markdown prose.";
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
      description = "When object property names are quoted.";
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
    semi = mkOption {
      description = "Print semicolons.";
      type = types.nullOr types.bool;
      example = true;
      default = null;
    };
    singleAttributePerLine = mkOption {
      description = "Enforce one attribute per line in HTML, Vue, and JSX.";
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
    sortImports = mkOption {
      description = "Import-sorting configuration.";
      type = types.nullOr sortImportsConfigType;
      default = null;
    };
    sortPackageJson = mkOption {
      description = "Sort `package.json` keys.";
      type = types.nullOr (types.either types.bool sortPackageJsonConfigType);
      example = {
        sortScripts = true;
      };
      default = null;
    };
    sortTailwindcss = mkOption {
      description = "Tailwind class sorting configuration.";
      type = types.nullOr sortTailwindcssConfigType;
      default = null;
    };
    tabWidth = mkOption {
      description = "Number of spaces per indentation level.";
      type = types.nullOr types.int;
      example = 2;
      default = null;
    };
    trailingComma = mkOption {
      description = "Print trailing commas where possible in multi-line structures.";
      type = types.nullOr (
        types.enum [
          "all"
          "es5"
          "none"
        ]
      );
      example = "all";
      default = null;
    };
    useTabs = mkOption {
      description = "Indent with tabs instead of spaces.";
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
  };

  oxfmtOverrideType = types.submodule {
    options = {
      excludeFiles = mkOption {
        description = "Glob patterns to exclude from this override.";
        type = types.nullOr (types.listOf types.str);
        default = null;
      };
      files = mkOption {
        description = "Glob patterns to match files for this override.";
        type = types.listOf types.str;
        example = [
          "*.md"
          "*.html"
        ];
      };
      options = mkOption {
        description = "Format options to apply for matched files.";
        type = types.submodule {
          options = formatOptions;
        };
        default = { };
      };
    };
  };

  # Configuration schema for Oxfmt, used to generate .oxfmtrc.json.
  # Definition taken from:
  # https://raw.githubusercontent.com/oxc-project/oxc/refs/heads/main/npm/oxfmt/configuration_schema.json
  settingsSchema = formatOptions // {
    ignorePatterns = mkOption {
      description = "Ignore files matching these glob patterns.";
      type = types.nullOr (types.listOf types.str);
      example = [ "dist/**" ];
      default = null;
    };
    overrides = mkOption {
      description = "Per-file formatter option overrides.";
      type = types.nullOr (types.listOf oxfmtOverrideType);
      example = [
        {
          files = [ "*.md" ];
          options.printWidth = 80;
        }
      ];
      default = null;
    };
  };

  removeNullValues =
    value:
    if builtins.isAttrs value then
      filterAttrs (_n: v: v != null) (lib.mapAttrs (_n: v: removeNullValues v) value)
    else if builtins.isList value then
      builtins.filter (v: v != null) (builtins.map removeNullValues value)
    else
      value;

  settingsFile =
    let
      settings = removeNullValues cfg.settings;
    in
    if settings != { } then configFormat.generate ".oxfmtrc.json" settings else null;
in
{
  meta.maintainers = [ "jnsgruk" ];

  imports = [
    (mkFormatterModule {
      name = "oxfmt";
      includes = [
        "*.cjs"
        "*.css"
        "*.graphql"
        "*.hbs"
        "*.html"
        "*.js"
        "*.json"
        "*.json5"
        "*.jsonc"
        "*.jsx"
        "*.md"
        "*.mdx"
        "*.mjs"
        "*.mustache"
        "*.scss"
        "*.ts"
        "*.tsx"
        "*.vue"
        "*.yaml"
        "*.yml"
      ];
    })
  ];

  options.programs.oxfmt = {
    settings = settingsSchema;
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.oxfmt = {
      options = optionals (settingsFile != null) [
        "--config"
        (toString settingsFile)
      ];
    };
  };
}
