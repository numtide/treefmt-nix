{ nixpkgs, treefmt-nix, ... }:
let
  inherit (nixpkgs) lib;
in
{
  testConfigGeneration = treefmt-nix.mkConfigFile
    nixpkgs
    {
      formatter = lib.listToAttrs
        (map
          (name: {
            name = name;
            value = { enable = true; };
          })
          treefmt-nix.formatter.names
        );
    };
}
