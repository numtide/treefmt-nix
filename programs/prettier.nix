{ lib, pkgs, config, ... }:
let
  cfg = config.programs.prettier;
in
{
  options.programs.prettier = {
    enable = lib.mkEnableOption "prettier";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.nodePackages.prettier;
      defaultText = lib.literalExpression "pkgs.nodePackages.prettier";
      description = lib.mdDoc ''
        prettier derivation to use.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.prettier = {
      command = cfg.package;
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
        "*.tsx"
        "*.yaml"
        "*.yml"
      ];
    };
  };
}
