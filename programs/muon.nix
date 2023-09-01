{ lib
, pkgs
, config
, ...
}:
let
  cfg = config.programs.muon;
in
{
  options.programs.muon = {
    enable = lib.mkEnableOption "muon";
    package = lib.mkPackageOption pkgs "muon" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.muon = {
      command = cfg.package;
      options = [ "fmt" "-i" ];
      includes = [
        "meson.build"
        "meson.options"
        "meson_options.txt"
      ];
    };
  };
}
