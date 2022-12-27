{ pkgs, ... }:
{
  config.formatter.gofumpt = {
    command = pkgs.gofumpt;
    options = [ "-w" ];
    includes = [ "*.go" ];
  };
}
