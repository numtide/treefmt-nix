{
  lib,
  pkgs,
  config,
  mkFormatterModule,
  ...
}:
let
  cfg = config.programs.ocamlformat;

  detectVersion =
    configFile: pkgSet:
    let
      optionValue =
        list:
        assert lib.assertMsg (list != [ ]) "treefmt-nix: Unable to detect ocamlformat version from file";
        lib.elemAt list (lib.length list - 1);
      trim = lib.replaceStrings [ " " ] [ "" ];
    in
    lib.getAttr "ocamlformat_${lib.replaceStrings [ "." ] [ "_" ] (optionValue (lib.findFirst (option: lib.head option == "version") [ ] (lib.map (n: lib.splitString "=" (trim n)) (lib.splitString "\n" (lib.readFile configFile)))))}" pkgSet;
in
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "ocamlformat";
      args = [ "-i" ];
      includes = [
        "*.ml"
        "*.mli"
      ];
    })
  ];

  options.programs.ocamlformat = {
    pkgs = lib.mkOption {
      type = lib.types.lazyAttrsOf lib.types.raw;
      description = "The package set used to get the ocamlformat package at a specific version.";
      default = pkgs;
      defaultText = lib.literalMD "Nixpkgs from context";
    };

    configFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      description = "Path to the .ocamlformat file. Used to pick the right version of ocamlformat if passed.";
      default = null;
    };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.ocamlformat = {
      command = if cfg.configFile == null then cfg.package else detectVersion cfg.configFile cfg.pkgs;
    };
  };
}
