{ pkgs, ... }:
{
  config.formatter.shfmt = {
    command = pkgs.shfmt;
    options = [ "-i" "2" "-s" "-w" ];
    includes = [ "*.sh" ];
  };
}
