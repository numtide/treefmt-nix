{ pkgs, ... }:
{
  config.formatter.cabal-fmt = {
    command = pkgs.haskellPackages.cabal-fmt;
    options = [ "--inplace" ];
    includes = [ "*.cabal" ];
  };
}
