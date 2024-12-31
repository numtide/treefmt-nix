{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  cfg = config.programs.deno;
in
{
  options.programs.deno = {
    enable = mkEnableOption "deno";
    package = mkOption {
      type = types.package;
      default = pkgs.deno;
      defaultText = lib.literalExpression "pkgs.deno";
      description = ''
        deno derivation to use.
      '';
    };

    # Deno-specific includes override
    includes = mkOption {
      description = "Path / file patterns to include for Deno";
      type = types.listOf types.str;
      default = [
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
    };

    # Deno-specific includes override
    excludes = mkOption {
      description = "Path / file patterns to exclude for Deno";
      type = types.listOf types.str;
      default = [ ];
    };
  };

  config = mkIf cfg.enable {
    settings.formatter.deno = {
      command = cfg.package;
      options = lib.mkBefore [ "fmt" ];
      includes = cfg.includes;
      excludes = cfg.excludes;
    };
  };
}
