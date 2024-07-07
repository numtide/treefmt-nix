{ lib, pkgs, config, ... }:
let
  cfg = config.programs.elm-format;
in
{
  options.programs.elm-format = {
    enable = lib.mkEnableOption "elm-format";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.elmPackages.elm-format;
      defaultText = lib.literalExpression "pkgs.elmPackages.elm-format";
      description = ''
        elm-format derivation to use.
      '';
    };

    includes = lib.mkOption {
      description = "Path / file patterns to include for Biome";
      type = lib.types.listOf lib.types.str;
      example = [ "*.elm" ];
      default = [ "*.elm" ];
    };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.elm-format = {
      command = cfg.package;
      options = [ "--yes" ];
      inherit (cfg) includes;
    };
  };
}
