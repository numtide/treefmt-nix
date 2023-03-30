{ lib, pkgs, config, ... }:
let
  cfg = config.programs.dhall;
in
{
  options.programs.dhall = {
    enable = lib.mkEnableOption "dhall";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.dhall;
      defaultText = lib.literalExpression "pkgs.dhall";
      description = lib.mdDoc ''
        dhall derivation to use.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.dhall = {
      command = cfg.package;
      options = [ "format" ];
      includes = [ "*.dhall" ];
    };
  };
}
