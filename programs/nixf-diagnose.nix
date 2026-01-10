{
  config,
  lib,
  mkFormatterModule,
  ...
}:

let
  cfg = config.programs.nixf-diagnose;
in
{
  meta.maintainers = [
    "NixOS/nixpkgs-ci"
  ];

  imports = [
    (mkFormatterModule {
      name = "nixf-diagnose";
      includes = [ "*.nix" ];
    })
  ];

  options.programs.nixf-diagnose = {
    autoFix = lib.mkOption {
      description = "Whether to automatically apply fixes to source files.";
      default = true; # enabled by default since treefmt is not a linter but a formatter
      type = lib.types.bool;
    };
    ignore = lib.mkOption {
      description = "Diagnostics to ignore, specified by their ID.";
      example = [ "sema-primop-overridden" ];
      default = [ ];
      type = with lib.types; listOf str;
    };
    only = lib.mkOption {
      description = "Only run this diagnostic.";
      example = "sema-primop-overridden";
      default = null;
      type = with lib.types; nullOr str;
    };
    variableLookup = lib.mkOption {
      description = "Whether to enable variable lookup analysis.";
      example = false;
      default = null;
      type = with lib.types; nullOr bool;
    };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.nixf-diagnose.options =
      lib.optional cfg.autoFix "--auto-fix"
      ++ map (id: "--ignore=${id}") cfg.ignore
      ++ lib.optional (cfg.only != null) "--only=${cfg.only}"
      ++ lib.optional (
        cfg.variableLookup != null
      ) "--variable-lookup=${lib.boolToString cfg.variableLookup}";
  };
}
