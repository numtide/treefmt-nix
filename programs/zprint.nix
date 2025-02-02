{
  lib,
  config,
  mkFormatterModule,
  ...
}:
let
  cfg = config.programs.zprint;
in
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "zprint";
      args = [ "--write" ];
      includes = [
        "*.clj"
        "*.cljc"
        "*.cljs"
        "*.edn"
      ];
    })
  ];

  options.programs.zprint = {
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
      # zprint options must be first
      options = lib.mkOrder 100 (lib.optional (cfg.zprintOpts != null) cfg.zprintOpts);
    };
  };
}
