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

            To access the final treefmt package that uses this configuration,
            evaluate `config.treefmt.build.wrapper`.
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
