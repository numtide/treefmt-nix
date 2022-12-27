{ pkgs, ... }:
{
  config.formatter.shellcheck = {
    command = pkgs.shellcheck;
    includes = [ "*.sh" ];
  };
}
