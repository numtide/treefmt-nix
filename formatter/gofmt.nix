{ pkgs, ... }:
{
  config.formatter.gofmt = {
    command = "${pkgs.go}/bin/gofmt";
    options = [ "-w" ];
    includes = [ "*.go" ];
  };
}
