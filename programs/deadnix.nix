{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.programs.deadnix;
in
{
  options.programs.deadnix = {
    enable = lib.mkEnableOption "deadnix";
    package = lib.mkPackageOption pkgs "deadnix" { };
    no-lambda-arg = lib.mkEnableOption "Don't check lambda parameter arguments";
    no-lambda-pattern-names = lib.mkEnableOption "Don't check lambda attrset pattern names (don't break nixpkgs callPackage)";
    no-underscore = lib.mkEnableOption "Don't check any bindings that start with a _";
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.deadnix = {
      command = cfg.package;
      options =
        [ "--edit" ]
        ++ (lib.optional cfg.no-lambda-arg "--no-lambda-arg")
        ++ (lib.optional cfg.no-lambda-pattern-names "--no-lambda-pattern-names")
        ++ (lib.optional cfg.no-underscore "--no-underscore");
      includes = [ "*.nix" ];
    };
  };
}
