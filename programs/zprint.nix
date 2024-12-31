{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.programs.zprint;
in
{
  meta.maintainers = [ ];

  options.programs.zprint = {
    enable = lib.mkEnableOption "zprint";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.zprint;
      defaultText = lib.literalExpression "pkgs.zprint";
      description = ''
        zprint derivation to use.
      '';
    };
    zprintOpts = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "{:width 90}";
      description = ''
        Clojure map containing zprint options.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.zprint = {
      command = cfg.package;
      # zprint options must be first
      options = (lib.optional (cfg.zprintOpts != null) cfg.zprintOpts) ++ [ "--write" ];
      includes = [
        "*.clj"
        "*.cljc"
        "*.cljs"
        "*.edn"
      ];
    };
  };
}
