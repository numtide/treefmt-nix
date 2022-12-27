{ pkgs, ... }:
{
  config.formatter.terraform = {
    command = pkgs.terraform;
    options = [ "fmt" ];
    includes = [ "*.tf" ];
  };
}
