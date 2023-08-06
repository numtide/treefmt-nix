{ lib, pkgs, config, ... }:
let
  cfg = config.programs.zprint;
in
{
  options.programs.zprint = {
    enable = lib.mkEnableOption "zprint";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.zprint;
      defaultText = lib.literalExpression "pkgs.zprint";
      description = lib.mdDoc ''
        zprint derivation to use.
      '';
    };
    zprintOpts = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "{:width 90}";
      description = lib.mdDoc ''
        Clojure map containing zprint options.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.zprint = {
      command = "${lib.getBin cfg.package}/bin/zprint";
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
