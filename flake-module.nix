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

            Use `config.treefmt.build.wrapper` to get access to the resulting treefmt
            package based on this configuration.
            
            The following sets treefmt up as the default formatter 
            used by the `nix fmt` command: 
            
            ```
            perSystem = { config, ... }: {
              formatter = config.treefmt.build.wrapper;
            };
            ```
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
