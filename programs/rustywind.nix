{
  config,
  lib,
  mkFormatterModule,
  pkgs,
  ...
}:
let
  inherit (lib.types)
    bool
    enum
    nullOr
    oneOf
    path
    str
    ;

  cfg = config.programs.rustywind;
  configFormat = pkgs.formats.json { };

  settingsSchema = lib.mkOption {
    default = { };
    example = {
      sortOrder = [
        "flex"
        "p-4"
      ];
    };
    description = ''
      Configuration to generate {file}`rustywind.json` with.

      When set, RustyWind will use the config file to derive configurations.

      The config file current only supports json with one property sortOrder, e.g. `{ "sortOrder": ["class1", ...] }`.
    '';
    type = lib.types.submodule { freeformType = configFormat.type; };
  };

  settingsFile =
    if cfg.settings != { } then configFormat.generate "rustywind.json" cfg.settings else null;
in
{
  meta.maintainers = [ "juangiordana" ];

  imports = [
    (mkFormatterModule {
      name = "rustywind";
      args = [ "--write" ];
      stdinArgs = [ "--stdin" ];
      includes = [
        "*.astro"
        "*.blade"
        "*.django"
        "*.djhtml"
        "*.ejs"
        "*.erb"
        "*.handlebars"
        "*.hbs"
        "*.htm"
        "*.html"
        "*.j2"
        "*.jinja"
        "*.jinja2"
        "*.jsx"
        "*.liquid"
        "*.lit"
        "*.php"
        "*.phtml"
        "*.rb"
        "*.svelte"
        "*.tsx"
        "*.twig"
      ];
    })
  ];

  options.programs.rustywind = {
    settings = settingsSchema;

    allow-duplicates = lib.mkOption {
      type = nullOr bool;
      default = null;
      example = true;
      description = "When set, RustyWind will not delete duplicated classes.";
    };

    preserve-whitespace = lib.mkOption {
      type = nullOr bool;
      default = null;
      example = true;
      description = "When set, RustyWind will keep the original whitespace between classes, e.g. multiline class lists.";
    };

    output-css-file = lib.mkOption {
      type = nullOr (oneOf [
        str
        path
      ]);
      default = null;
      example = "./src/output.css";
      description = "When set RustyWind will determine the sort order by the order the class appear in the the given css file.";
    };

    vite-css = lib.mkOption {
      type = nullOr str;
      default = null;
      example = "http://127.0.0.1:5173/src/assets/main.css";
      description = "When set RustyWind will determine the sort order by the order the class appear in the CSS file that Vite generates.";
    };

    skip-ssl-verification = lib.mkOption {
      type = nullOr bool;
      default = null;
      example = true;
      description = "When set, RustyWind will skip SSL verification for the `vite-css` option.";
    };

    custom-regex = lib.mkOption {
      type = nullOr str;
      default = null;
      example = ''classes\\(([^)]*)\\)'';
      description = "Uses a custom regex whose `classes` or first capture contains the class list.";
    };

    class-wrapping = lib.mkOption {
      type = nullOr (enum [
        "no-wrapping"
        "comma-single-quotes"
        "comma-double-quotes"
      ]);
      default = null;
      example = "no-wrapping";
      description = "Specifies how individual classes are wrapped.";
    };

    tailwind-prefix = lib.mkOption {
      type = nullOr str;
      default = null;
      example = "tw";
      description = "Tailwind prefix used when sorting classes, e.g. `tw` for `tw:` or `tw-` classes.";
    };

    language = lib.mkOption {
      type = nullOr (enum [
        "astro"
        "blade"
        "django"
        "ejs"
        "erb"
        "handlebars"
        "html"
        "jinja"
        "jsx"
        "liquid"
        "lit"
        "php"
        "ruby"
        "svelte"
        "tsx"
        "twig"
      ]);
      default = null;
      example = "svelte";
      description = "Source language to use for all inputs.";
    };

    stdin-filename = lib.mkOption {
      type = nullOr (oneOf [
        str
        path
      ]);
      default = null;
      example = "./src/routes/+layout.svelte";
      description = "Filename used to infer the source language of stdin.";
    };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.rustywind = {
      options =
        lib.optionals (cfg.allow-duplicates == true) [ "--allow-duplicates" ]
        ++ lib.optionals (cfg.preserve-whitespace == true) [ "--preserve-whitespace" ]
        ++ lib.optionals (settingsFile != null) [
          "--config-file"
          (toString settingsFile)
        ]
        ++ lib.optionals (cfg.output-css-file != null) [
          "--output-css-file"
          (toString cfg.output-css-file)
        ]
        ++ lib.optionals (cfg.vite-css != null) [
          "--vite-css"
          cfg.vite-css
        ]
        ++ lib.optionals (cfg.skip-ssl-verification == true) [ "--skip-ssl-verification" ]
        ++ lib.optionals (cfg.custom-regex != null) [
          "--custom-regex"
          cfg.custom-regex
        ]
        ++ lib.optionals (cfg.class-wrapping != null) [
          "--class-wrapping"
          cfg.class-wrapping
        ]
        ++ lib.optionals (cfg.tailwind-prefix != null) [
          "--tailwind-prefix"
          cfg.tailwind-prefix
        ]
        ++ lib.optionals (cfg.language != null) [
          "--language"
          cfg.language
        ]
        ++ lib.optionals (cfg.stdin-filename != null) [
          "--stdin-filename"
          cfg.stdin-filename
        ];
    };
  };
}
