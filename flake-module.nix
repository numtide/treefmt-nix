{
  self,
  lib,
  flake-parts-lib,
  ...
}:
let
  inherit (flake-parts-lib)
    mkPerSystemOption
    ;
  inherit (lib)
    mkOption
    types
    ;
  treefmt-nix-lib = import ./.;
in
{
  options = {
    perSystem = mkPerSystemOption (
      {
        config,
        pkgs,
        ...
      }:
      {
        options.treefmt = mkOption {
          description = ''
            Project-level treefmt configuration

            Use `config.treefmt.build.wrapper` to get access to the resulting treefmt
            package based on this configuration.

            By default treefmt-nix will set the `formatter.<system>` attribute of the flake,
            used by the `nix fmt` command.
          '';
          type = treefmt-nix-lib.submoduleWith lib {
            modules = [
              {
                options.pkgs = lib.mkOption {
                  default = pkgs;
                  defaultText = "`pkgs` (module argument of `perSystem`)";
                };
                options.flakeFormatter = lib.mkOption {
                  type = types.bool;
                  default = true;
                  description = ''
                    Enables `treefmt` the default formatter used by the `nix fmt` command
                  '';
                };
                options.flakeCheck = lib.mkOption {
                  type = types.bool;
                  default = true;
                  description = ''
                    Add a flake check to run `treefmt`
                  '';
                };
                options.projectRoot = lib.mkOption {
                  type = types.path;
                  default = self;
                  defaultText = lib.literalExpression "self";
                  description = ''
                    Path to the root of the project on which treefmt operates
                  '';
                };
              }
            ];
          };
          default = { };
        };
        config = {
          checks = lib.mkIf config.treefmt.flakeCheck {
            treefmt = config.treefmt.build.check config.treefmt.projectRoot;
          };
          formatter = lib.mkIf config.treefmt.flakeFormatter (lib.mkDefault config.treefmt.build.wrapper);
        };
      }
    );
  };
}
