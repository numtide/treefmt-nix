{ pkgs, ... }:
{
  config.formatter.stylish-haskell = {
    command = pkgs.stylish-haskell;
    options = [ "-i" "-r" ];
    includes = [ "*.hs" ];
  };
}
