{
  description = "treefmt nix configuration modules";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

  outputs =
    { self, nixpkgs }:
    let
      inherit (nixpkgs) lib;
      eachSystem = lib.genAttrs [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];
    in
    {
      lib = import ./.;

      flakeModule = ./flake-module.nix;

      formatter = eachSystem (system: self.checks.${system}.self-wrapper);

      checks = eachSystem (
        system:
        (import ./checks {
          pkgs = import nixpkgs {
            inherit system;
            config = {
              # required for packer
              allowUnfree = true;
            };
          };
          treefmt-nix = self.lib;
        })
      );
    };
}
