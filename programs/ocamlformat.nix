{ lib
, pkgs
, config
, ...
}:
let
  l = lib // builtins;
  cfg = config.programs.ocamlformat;

  detectVersion = configFile: pkgSet:
    let
      optionValue = list:
        assert l.assertMsg (list != [ ]) "treefmt-nix: Unable to detect ocamlformat version from file";
        l.elemAt list (l.length list - 1);
      trim = l.replaceStrings [ " " ] [ "" ];
    in
    l.getAttr "ocamlformat_${
      l.replaceStrings ["."] ["_"]
      (optionValue (l.findFirst (option: l.head option == "version") []
          (l.map (n: l.splitString "=" (trim n)) (l.splitString "\n" (l.readFile configFile)))))
    }"
      pkgSet;
in
{
  options.programs.ocamlformat = {
    enable = l.mkEnableOption "ocamlformat";
    package = l.mkPackageOption pkgs "ocamlformat" { };

    pkgs = l.mkOption {
      type = l.types.lazyAttrsOf l.types.raw;
      description = "The package set used to get the ocamlformat package at a specific version.";
      default = pkgs;
      defaultText = lib.literalMD "Nixpkgs from context";
    };

    configFile = l.mkOption {
      type = l.types.nullOr l.types.path;
      description = "Path to the .ocamlformat file. Used to pick the right version of ocamlformat if passed.";
      default = null;
    };
  };

  config = l.mkIf cfg.enable {
    settings.formatter.ocamlformat = {
      command =
        if l.isNull cfg.configFile
        then cfg.package
        else detectVersion cfg.configFile cfg.pkgs;
      options = [ "-i" ];
      includes = [ "*.ml" "*.mli" ];
    };
  };
}
