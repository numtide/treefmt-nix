{
  description = "treefmt nix configuration modules";

  outputs = { self }: {
    lib = import ./.;
    flakeModule = ./flake-module.nix;
  };
}
