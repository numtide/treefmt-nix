{ lib, pkgs, config, ... }:
let
  cfg = config.programs.texfmt;
in
{
  meta.maintainers = [ ];

  options.programs.texfmt = {
    enable = lib.mkEnableOption "texfmt";
    package = lib.mkPackageOption pkgs "tex-fmt" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.texfmt = {
      command = lib.getExe' cfg.package "tex-fmt";
      options = [ ];
      includes = [
        "*.tex"
        "*.sty"
        "*.cls"
        "*.bib"
        "*.cmh"
      ];
    };
  };
}
