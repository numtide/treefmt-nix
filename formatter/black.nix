{ pkgs, ... }:
{
  config.formatter.black = {
    command = pkgs.black;
    includes = [ "*.py" ];
  };
}
