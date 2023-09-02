{ lib
, pkgs
, config
, ...
}:
let
  inherit (lib) mkEnableOption mkIf mkOption types;

  cfg = config.programs.deno;
in
{
  options.programs.deno = {
    enable = mkEnableOption "deno";
    package = mkOption {
      type = types.package;
      default = pkgs.deno;
      defaultText = lib.literalExpression "pkgs.deno";
      description = lib.mdDoc ''
        deno derivation to use.
      '';
    };

    # Deno-specific includes override
    includes = mkOption {
      description = "Path / file patterns to include for Deno";
      type = types.listOf types.str;
      default = [
        "*.js"
        "*.json"
        "*.jsonc"
        "*.jsx"
        "*.markdown"
        "*.md"
        "*.ts"
        "*.tsx"
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
      options = [ "fmt" ];
      includes = cfg.includes;
      excludes = cfg.excludes;
    };
  };
}
