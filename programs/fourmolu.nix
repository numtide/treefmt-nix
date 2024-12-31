{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.programs.fourmolu;
in
{
  meta.maintainers = [ ];

  options.programs.fourmolu = {
    enable = lib.mkEnableOption "fourmolu";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.haskellPackages.fourmolu;
      defaultText = lib.literalExpression "pkgs.haskellPackages.fourmolu";
      description = ''
        fourmolu derivation to use.
      '';
    };
    ghcOpts = lib.mkOption {
      description = "Which GHC language extensions to enable";
      default = [
        "BangPatterns"
        "PatternSynonyms"
        "TypeApplications"
      ];
    };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.fourmolu = {
      command = cfg.package;
      options =
        [
          "-i"
          "-c"
        ]
        ++ (lib.concatMap (x: [
          "--ghc-opt"
          "-X${x}"
        ]) cfg.ghcOpts);
      includes = [ "*.hs" ];
    };
  };
}
