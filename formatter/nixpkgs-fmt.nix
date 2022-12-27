{ pkgs, ... }:
{
  config.formatter.nixpkgs-fmt = {
    command = pkgs.nixpkgs-fmt;
    includes = [ "*.nix" ];
  };
}
