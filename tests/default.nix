{ pkgs, treefmt-nix, ... }:
let
  inherit (pkgs) lib;

  toConfig = name:
    treefmt-nix.mkConfigFile pkgs {
      programs.${name}.enable = true;
    };

  borsToml =
    let
      checks = map (name: ''  "check ${name} [x86_64-linux]"'') (lib.attrNames self);
    in
    pkgs.writeText "bors.toml" ''
      # Generated with ./bors.toml.sh
      cut_body_after = "" # don't include text from the PR body in the merge commit message
      status = [
        "Evaluate flake.nix",
        ${lib.concatStringsSep ",\n  " checks},
      ]
    '';

  self = {
    testEmptyConfig = treefmt-nix.mkConfigFile pkgs { };

    testWrapper = treefmt-nix.mkWrapper pkgs {
      projectRootFile = "flake.nix";
    };

    # Check if the bors.toml needs to be updated
    testBorsToml = pkgs.runCommand
      "test-bors-toml"
      {
        passthru.borsToml = borsToml;
      } ''
      diff ${../bors.toml} ${borsToml}
      touch $out
    '';
  } // (
    pkgs.lib.listToAttrs (map
      (name: {
        name = name;
        value = toConfig name;
      })
      treefmt-nix.programs.names
    )
  );
in
self
