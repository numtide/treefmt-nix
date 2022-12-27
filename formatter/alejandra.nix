{ pkgs, ... }:
{
  formatter.alejandra = {
    command = pkgs.alejandra;
    includes = [ "*.nix" ];
  };
}
