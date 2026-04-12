{
  lib,
  config,
  mkFormatterModule,
  ...
}:
let
  cfg = config.programs.oxfmt;
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
        "*.less"
        "*.md"
        "*.mdx"
        "*.mjs"
        "*.mustache"
        "*.scss"
        "*.toml"
        "*.ts"
        "*.tsx"
        "*.vue"
        "*.yaml"
        "*.yml"
      ];
    })
  ];

  options.programs.oxfmt = {
    # See supported extensions: https://oxc.rs/docs/guide/usage/formatter/quickstart.html#pre-commit-with-lint-staged
    allFiles = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Format all files by using a wildcard include pattern. Passes --no-error-on-unmatched-pattern so unsupported files are silently skipped.";
    };
  };

  config = lib.mkIf (cfg.enable && cfg.allFiles) {
    settings.formatter.oxfmt = {
      includes = [ "*" ];
      options = [ "--no-error-on-unmatched-pattern" ];
    };
  };
}
