{
  lib,
  config,
  mkFormatterModule,
  ...
}:
let
  cfg = config.programs.deadnix;
in
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "deadnix";
      args = [ "--edit" ];
      includes = [ "*.nix" ];
    })
  ];

  options.programs.deadnix = {
    no-lambda-arg = lib.mkEnableOption "Don't check lambda parameter arguments";
    no-lambda-pattern-names = lib.mkEnableOption "Don't check lambda attrset pattern names (don't break nixpkgs callPackage)";
    no-underscore = lib.mkEnableOption "Don't check any bindings that start with a _";
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.deadnix.options =
      (lib.optional cfg.no-lambda-arg "--no-lambda-arg")
      ++ (lib.optional cfg.no-lambda-pattern-names "--no-lambda-pattern-names")
      ++ (lib.optional cfg.no-underscore "--no-underscore");
  };
}
