{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) types;

  cfg = config.programs.ocamlformat;

  detectVersion = configFile: pkgSet: let
    optionValue = list:
      assert lib.assertMsg (list != []) "treefmt/ocamlformat: Unable to find version in the config file";
        lib.elemAt list (lib.length list - 1);
  in
    builtins.getAttr "ocamlformat_${
      builtins.replaceStrings ["."] ["_"]
      (optionValue (lib.findFirst (option: builtins.head option == "version") []
          (builtins.map (n: lib.splitString "=" n) (lib.splitString "\n" (builtins.readFile configFile)))))
    }"
    pkgSet;
in {
  options.programs.ocamlformat = {
    enable = lib.mkEnableOption "ocamlformat";
    package = lib.mkOption {
      type = types.oneOf [
        types.path
        types.package

        (types.submodule {
          options = {
            pkgs = lib.mkOption {
              type = types.lazyAttrsOf types.raw;
              default = pkgs;
            };
            path = lib.mkOption {type = types.path;};
          };
        })
      ];
      default = pkgs.ocamlformat;
    };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.ocamlformat = {
      command =
        if lib.isDerivation cfg.package
        then cfg.package
        else detectVersion cfg.package.path cfg.package.pkgs;
      options = ["-i"];
      includes = ["*.ml" "*.mli"];
    };
  };
}
