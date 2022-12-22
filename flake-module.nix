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
            treefmt flake module options
          '';
          type = types.submodule {
            options = {
              config = mkOption {
                description = "treefmt-nix configuration";
                type = types.submoduleWith {
                  modules = (import ./.).all-modules pkgs;
                };
              };
              module = mkOption {
                type = types.raw; # TODO: module type?
                description = "Evaluated module of treefmt-nix";
                default =
                  (import ./.).evalModule pkgs config.treefmt.config;
              };
              programs = mkOption {
                type = types.attrsOf types.package;
                description = "Attrset of formatter programs enabled in configuration";
                default =
                  pkgs.lib.concatMapAttrs
                    (k: v:
                      if v.enable
                      then { "${k}" = v.package; }
                      else { })
                    config.treefmt.module.config.programs;
              };
              wrapper = mkOption {
                type = types.package;
                description = "Wrapper treefmt using the current configuration";
                default = config.treefmt.module.config.build.wrapper;
              };
            };
          };
        };
        config = {
          checks.treefmt = config.treefmt.module.config.build.check self;
        };
      });
  };
}
