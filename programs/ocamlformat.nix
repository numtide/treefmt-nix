{ lib
, pkgs
, config
, ...
}:
let
  inherit (lib) types;

  cfg = config.programs.ocamlformat;

  detectVersion = configFile:
    let
      optionValue = list:
        assert lib.assertMsg (list != [ ]) "treefmt/ocamlformat: Unable to find version in the config file";
        lib.elemAt list (lib.length list - 1);
    in
    builtins.getAttr "ocamlformat_${
      builtins.replaceStrings ["."] ["_"]
      (optionValue (lib.findFirst (option: builtins.head option == "version") []
          (builtins.map (n: lib.splitString "=" n) (lib.splitString "\n" (builtins.readFile configFile)))))
    }"
      pkgs;
in
{
  options.programs.ocamlformat = {
    enable = lib.mkEnableOption "ocamlformat";
    package = lib.mkOption {
      type = types.either types.path types.package;
      default = pkgs.ocamlformat;
    };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.ocamlformat = {
      command =
        if lib.isPath cfg.package
        then detectVersion cfg.package
        else cfg.package;
      options = [ "-i" ];
      includes = [ "*.ml" "*.mli" ];
    };
  };
}
