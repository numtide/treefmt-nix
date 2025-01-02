{
  lib,
  config,
  mkFormatterModule,
  ...
}:
let
  cfg = config.programs.ormolu;
in
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "ormolu";
      args = [
        "--mode"
        "inplace"
        "--check-idempotence"
      ];
      includes = [ "*.hs" ];
    })
  ];

  options.programs.ormolu = {
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
    settings.formatter.ormolu = {
      options = (
        lib.concatMap (x: [
          "--ghc-opt"
          "-X${x}"
        ]) cfg.ghcOpts
      );
    };
  };
}
