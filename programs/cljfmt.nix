{ lib, pkgs, config, ... }:
let
  cfg = config.programs.cljfmt;
in
{
  options.programs.cljfmt = {
    enable = lib.mkEnableOption "cljfmt";
    package = lib.mkPackageOption pkgs "cljfmt" { };

    includes = lib.mkOption {
      description = "Clojure file patterns to format";
      type = lib.types.listOf lib.types.str;
      default = [ "*.clj" "*.cljc" "*.cljs" "*.cljx" ];
    };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.cljfmt = {
      command = cfg.package;
      options = [ "fix" ];
      includes = cfg.includes;
    };
  };
}
