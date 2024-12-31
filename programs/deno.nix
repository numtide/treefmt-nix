{ mkFormatterModule, ... }:
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "deno";
      args = [ "fmt" ];
      includes = [
        "*.css"
        "*.html"
        "*.js"
        "*.json"
        "*.jsonc"
        "*.jsx"
        "*.less"
        "*.markdown"
        "*.md"
        "*.sass"
        "*.scss"
        "*.ts"
        "*.tsx"
        "*.yaml"
        "*.yml"
      ];
    })
  ];
}
