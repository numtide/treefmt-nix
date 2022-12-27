{ pkgs, ... }:
{
  config.formatter.purs-tidy = {
    command = pkgs.nodePackages.purs-tidy;
    options = [ "format-in-place" ];
    includes = [
      "src/**/*.purs"
      "test/**/*.purs"
    ];
  };
}
