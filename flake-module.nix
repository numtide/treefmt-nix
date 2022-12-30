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
          apps.treefmt = {
            type = "app";
            program = "${self'.packages.treefmt}/bin/treefmt";
          };
          checks.treefmt = config.treefmt.build.check self;
          packages.treefmt = config.treefmt.build.wrapper;
        };
      });
  };
}
