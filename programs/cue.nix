{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.programs.cue;
in
{
  options.programs.cue = {
    enable = lib.mkEnableOption "cue";
    package = lib.mkPackageOption pkgs "cue" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.cue = {
      command = "${cfg.package}/bin/cue";
      options = [ "fmt" ];
      includes = [ "*.cue" ];
    };
  };
}
