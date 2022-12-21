{
  description = "treefmt nix configuration modules";

  outputs = { self }: rec {
    lib = import ./.;
    flakeModule = import ./flake-module.nix { treefmtLib = lib; };
  };
}
