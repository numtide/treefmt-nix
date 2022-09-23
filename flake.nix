{
  description = "treefmt nix configuration modules";

  outputs = { self, nixpkgs }: {
    lib = import ./.;
  };
}
