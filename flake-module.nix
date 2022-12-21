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
          checks.treefmt = pkgs.runCommandLocal "treefmt-check"
            {
              buildInputs = [ pkgs.git config.treefmt.wrapper ] ++ lib.attrValues config.treefmt.programs;
            }
            ''
              set -e
              treefmt --version
              # `treefmt --fail-on-change` is broken for purs-tidy; So we must rely
              # on git to detect changes. An unintended advantage of this approach
              # is that when the check fails, it will print a helpful diff at the end.
              PRJ=$TMP/project
              cp -r ${self} $PRJ
              chmod -R a+w $PRJ
              cd $PRJ
              git init
              git config user.email "nix@localhost"
              git config user.name Nix
              git add .
              git commit -m init
              treefmt --no-cache
              git status
              git --no-pager diff --exit-code
              touch $out
            '';
        };
      });
  };
}
