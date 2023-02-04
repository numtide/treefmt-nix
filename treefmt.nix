{ pkgs, treefmt-nix }:
treefmt-nix.mkWrapper pkgs {
  projectRootFile = "treefmt.nix";
  programs.nixpkgs-fmt.enable = true;
}
