{ pkgs, ... }:
{
  config.formatter.prettier = {
    command = pkgs.nodePackages.prettier;
    options = [ "--write" ];
    includes = [
      "*.css"
      "*.html"
      "*.js"
      "*.json"
      "*.jsx"
      "*.md"
      "*.mdx"
      "*.scss"
      "*.ts"
      "*.yaml"
    ];
  };
}
