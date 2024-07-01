{ lib, pkgs, config, ... }:
let
  cfg = config.programs.cabal-fmt;
in
{
  options.programs.cabal-fmt = {
    enable = lib.mkEnableOption "cabal-fmt";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.haskellPackages.cabal-fmt;
      defaultText = lib.literalExpression "pkgs.haskellPackages.cabal-fmt";
      description = ''
        cabal-fmt derivation to use.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.cabal-fmt = {
      command = cfg.package;
      options = [ "--inplace" ];
      includes = [ "*.cabal" ];
    };
  };
}
