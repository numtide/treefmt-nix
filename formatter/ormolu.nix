{ config, pkgs, lib, ... }:
{
  options.programs.ormolu = {
    # What to do with those ghcOpts?
    ghcOpts = lib.mkOption {
      description = "Which GHC language extensions to enable";
      default = [ "BangPatterns" "PatternSynonyms" "TypeApplications" ];
    };
  };

  config.formatter.ormolu = {
    command = pkgs.ormolu;
    options = [
      "--mode"
      "inplace"
      "--check-idempotence"
    ] ++ (lib.concatMap (x: [ "--ghc-opt" "-X${x}" ]) config.programs.ormolu.ghcOpts);
    includes = [ "*.hs" ];
  };
}
