{ self, lib, flake-parts-lib, ... }:
let
  inherit (flake-parts-lib)
    mkPerSystemOption;
  inherit (lib)
    mkOption
    types;
in
{
  options = {
    perSystem = mkPerSystemOption
      ({ config, self', inputs', pkgs, system, ... }: {
        options.treefmt = mkOption {
          description = ''
            Project-level treefmt configuration
          '';
          type = types.submoduleWith {
            modules = (import ./.).all-modules pkgs;
          };
        };
        config = {
          checks.treefmt = config.treefmt.build.check self;
        };
      });
  };
}
