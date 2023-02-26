{ pkgs, treefmt-nix, ... }:
let
  inherit (pkgs) lib;

  toConfig = name:
    treefmt-nix.mkConfigFile pkgs {
      programs.${name}.enable = true;
    };
in
{
  testEmptyConfig = treefmt-nix.mkConfigFile pkgs { };

  testWrapper = treefmt-nix.mkWrapper pkgs {
    projectRootFile = "flake.nix";
  };
} // (
  pkgs.lib.listToAttrs (map
    (name: {
      name = name;
      value = toConfig name;
    })
    treefmt-nix.programs.names
  )
)
