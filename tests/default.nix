{ nixpkgs, treefmt-nix, ... }:
let
  inherit (nixpkgs) lib;
in
{
  testConfigGeneration = treefmt-nix.mkConfigFile
    nixpkgs
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

  testEmptyConfig = treefmt-nix.mkConfigFile nixpkgs { };

  testWrapper = treefmt-nix.mkWrapper nixpkgs {
    projectRootFile = "flake.nix";
  };
}
