{ mkFormatterModule, ... }:
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
        "*.toml"
        "*.ts"
        "*.tsx"
        "*.vue"
        "*.yaml"
        "*.yml"
      ];
    })
  ];
}
