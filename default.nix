# A pure Nix library that handles the treefmt configuration.
let
  # The base module configuration that generates and wraps the treefmt config
  # with Nix.
  module-options = ./module-options.nix;

  # Program to formatter mapping
  formatter = import ./formatter;

  all-modules = nixpkgs: [
    {
      _module.args = {
        pkgs = nixpkgs;
        lib = nixpkgs.lib;
      };
    }
    module-options
  ]
  ++ formatter.modules;

  # Use the Nix module system to validate the treefmt config file format.
  #
  # nixpkgs is an instance of <nixpkgs> that contains treefmt.
  # configuration is an attrset used to configure the nix module
  evalModule = nixpkgs: configuration:
    nixpkgs.lib.evalModules {
      modules = all-modules nixpkgs ++ [ configuration ];
    };

  # Returns a treefmt.toml generated from the passed configuration.
  #
  # nixpkgs is an instance of <nixpkgs> that contains treefmt.
  # configuration is an attrset used to configure the nix module
  mkConfigFile = nixpkgs: configuration:
    let
      mod = evalModule nixpkgs configuration;
    in
    mod.config.build.configFile;

  # Returns an instance of treefmt, wrapped with some configuration.
  #
  # nixpkgs is an instance of <nixpkgs> that contains treefmt.
  # configuration is an attrset used to configure the nix module
  mkWrapper = nixpkgs: configuration:
    let
      mod = evalModule nixpkgs configuration;
    in
    mod.config.build.wrapper;
in
{
  inherit
    module-options
    formatter
    all-modules
    evalModule
    mkConfigFile
    mkWrapper
    ;
}
