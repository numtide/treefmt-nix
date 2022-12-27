{ pkgs, ... }:
{
  config.formatter.stylua = {
    command = pkgs.stylua;
    includes = [ "*.lua" ];
  };
}
