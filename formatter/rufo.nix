{ pkgs, ... }:
{
  config.formatter.rufo = {
    command = pkgs.rufo;
    options = [ "-x" ];
    includes = [ "*.rb" ];
  };
}
