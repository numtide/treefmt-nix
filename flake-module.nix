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

            By default treefmt-nix will set the `formatter.<system>` attribute of the flake,
            used by the `nix fmt` command.
          '';
          type = types.submoduleWith {
            modules = (import ./.).all-modules pkgs ++ [{
              options.flakeFormatter = lib.mkOption {
                type = types.bool;
                default = true;
                description = ''
                  Enables `treefmt` the default formatter used by the `nix fmt` command
                '';
              };
            }];
          };
        };
        config = {
          checks.treefmt = config.treefmt.build.check self;
          formatter = lib.mkIf config.treefmt.flakeFormatter (lib.mkDefault config.treefmt.build.wrapper);
        };
      });
  };
}
