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
      description = lib.mdDoc ''
        elm-format derivation to use.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.elm-format = {
      command = "${lib.getBin cfg.package}/bin/elm-format";
      options = [ " - -yes " ];
      includes = [ " * .elm " ];
    };
  };
}
