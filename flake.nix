{
  description = "treefmt nix configuration modules";

  outputs = { self }: {
    lib = import ./.;
  };
}
