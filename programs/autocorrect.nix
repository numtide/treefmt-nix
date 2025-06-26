{
  lib,
  pkgs,
  config,
  mkFormatterModule,
  ...
}:
let
  cfg = config.programs.autocorrect;
  configFormat = pkgs.formats.json { };

  # 0 - off, 1 - error, 2 - warning
  ruleType = lib.types.nullOr (
    lib.types.enum [
      "off"
      "error"
      "warning"
    ]
  );

  # Configuration schema for Autocorrect, which we generate .autocorrectrc with.
  # Definition taken from: https://github.com/huacnlee/autocorrect/raw/refs/heads/main/.autocorrectrc.template
  settingsSchema = {
    rules = lib.mkOption {
      description = "Configure rules for autocorrect formatting.";
      type = lib.types.nullOr (
        lib.types.submodule {
          options = {
            space-word = lib.mkOption {
              description = "Auto add spacing between CJK (Chinese, Japanese, Korean) and English words.";
              type = ruleType;
              example = "off";
              default = null;
            };

            space-punctuation = lib.mkOption {
              description = "Add space between some punctuations.";
              type = ruleType;
              example = "error";
              default = null;
            };

            space-bracket = lib.mkOption {
              description = "Add space between brackets (), [] when near the CJK.";
              type = ruleType;
              example = "error";
              default = null;
            };

            space-backticks = lib.mkOption {
              description = "Add space between ``, when near the CJK.";
              type = ruleType;
              example = "error";
              default = null;
            };

            space-dash = lib.mkOption {
              description = "Add space between dash `-`.";
              type = ruleType;
              example = "off";
              default = null;
            };

            space-dollar = lib.mkOption {
              description = "Add space between dollar $ when near the CJK.";
              type = ruleType;
              example = "off";
              default = null;
            };

            fullwidth = lib.mkOption {
              description = "Convert to fullwidth.";
              type = ruleType;
              example = "error";
              default = null;
            };

            no-space-fullwidth = lib.mkOption {
              description = "Remove space near the fullwidth.";
              type = ruleType;
              example = "error";
              default = null;
            };

            halfwidth-word = lib.mkOption {
              description = "Fullwidth alphanumeric characters to halfwidth.";
              type = ruleType;
              example = "error";
              default = null;
            };

            halfwidth-punctuation = lib.mkOption {
              description = "Fullwidth punctuations to halfwidth in english.";
              type = ruleType;
              example = "error";
              default = null;
            };

            spellcheck = lib.mkOption {
              description = "Spellcheck.";
              type = ruleType;
              example = "warning";
              default = null;
            };
          };
        }
      );
      default = null;
    };

    context = lib.mkOption {
      description = "Enable or disable in a specific context.";
      type = lib.types.nullOr (
        lib.types.submodule {
          options = {
            codeblock = lib.mkOption {
              description = "Enable or disable to format codeblock in Markdown or AsciiDoc etc.";
              type = ruleType;
              example = "error";
              default = null;
            };
          };
        }
      );
      default = null;
    };

    textRules = lib.mkOption {
      description = "Configure special rules for some texts.";
      type = lib.types.nullOr (lib.types.attrsOf ruleType);
      example = {
        "Hello你好" = "warning";
        "Hi你好" = "off";
      };
      default = null;
    };

    fileTypes = lib.mkOption {
      description = "Configure the files associations, you config is higher priority than default.";
      type = lib.types.nullOr (lib.types.attrsOf lib.types.str);
      example = {
        "rb" = "ruby";
        "Rakefile" = "ruby";
        "*.js" = "javascript";
        ".mdx" = "markdown";
      };
      default = null;
    };

    spellcheck = lib.mkOption {
      description = "Spellcheck configuration.";
      type = lib.types.nullOr (
        lib.types.submodule {
          options = {
            words = lib.mkOption {
              description = "Correct Words (Case insensitive) for by Spellcheck.";
              type = lib.types.nullOr (lib.types.listOf lib.types.str);
              example = [
                "GitHub"
                "App Store"
                "AppStore = App Store"
                "Git"
                "Node.js"
                "nodejs = Node.js"
                "VIM"
                "DNS"
                "HTTP"
                "SSL"
              ];
              default = null;
            };
          };
        }
      );
      default = null;
    };
  };

  settingsFile =
    let
      # Convert rule lib.types from strings to numeric values
      convertRuleTypes =
        attrs:
        lib.mapAttrsRecursive (
          _path: value:
          if isNull value then
            null
          else
            {
              "off" = 0;
              "error" = 1;
              "warning" = 2;
            }
            .${value} or value
        ) attrs;

      # remove all null values and convert rule lib.types
      settings = lib.filterAttrsRecursive (_n: v: v != null) (convertRuleTypes cfg.settings);
    in
    if settings != { } then configFormat.generate ".autocorrectrc" settings else null;
in
{
  meta.maintainers = [ "definfo" ];

  imports = [
    (mkFormatterModule {
      name = "autocorrect";
      args = [ "--fix" ];
      includes = [ "*" ];
    })
  ];

  options.programs.autocorrect = {
    threads = lib.mkOption {
      description = "Number of threads, 0 - use number of CPU. [default: 0]";
      type = lib.types.nullOr lib.types.int;
      example = 2;
      default = null;
    };

    # Represents the .autocorrectrc config schema
    settings = settingsSchema;
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.autocorrect = {
      options =
        (lib.optionals (!isNull cfg.threads) [
          "--threads"
          (toString cfg.threads)
        ])
        ++ (lib.optionals (settingsFile != null) [
          "--config"
          (toString settingsFile)
        ]);
    };
  };
}
