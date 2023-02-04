{ pkgs, treefmt-nix, ... }:
let
  inherit (pkgs) lib;
in
{
  testConfigGeneration = treefmt-nix.mkConfigFile
    pkgs
    {
      programs = lib.listToAttrs
        (map
          (name: {
            name = name;
            value = { enable = true; };
          })
          treefmt-nix.programs.names
        );
    };

  testEmptyConfig = treefmt-nix.mkConfigFile pkgs { };

  testWrapper = treefmt-nix.mkWrapper pkgs {
    projectRootFile = "flake.nix";
  };
}
