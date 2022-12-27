{ pkgs, ... }:
{
  config.formatter.elm-format = {
    command = pkgs.elmPackages.elm-format;
    options = [ " - -yes " ];
    includes = [ " * .elm " ];
  };
}
