{
  lib,
  config,
  mkFormatterModule,
  ...
}:
let
  cfg = config.programs.fourmolu;
in
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "fourmolu";
      package = [
        "haskellPackages"
        "fourmolu"
      ];
      args = [
        "-i"
        "-c"
      ];
      includes = [ "*.hs" ];
    })
  ];

  options.programs.fourmolu = {
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
      options = lib.concatMap (x: [
        "--ghc-opt"
        "-X${x}"
      ]) cfg.ghcOpts;
    };
  };
}
