{ lib
, pkgs
, config
, ...
}:
let
  cfg = config.programs.ocamlformat;
in
{
  options.programs.ocamlformat = {
    enable = lib.mkEnableOption "ocamlformat";
    package = lib.mkPackageOption pkgs "ocamlformat" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.ocamlformat = {
      command = cfg.package;
      options = [ "-i" ];
      includes = [ "*.ml" "*.mli" ];
    };
  };
}
