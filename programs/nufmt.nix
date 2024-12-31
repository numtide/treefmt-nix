{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.programs.nufmt;
in
{
  options.programs.nufmt = {
    enable = lib.mkEnableOption "nufmt";
    package = lib.mkPackageOption pkgs "nufmt" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.nufmt = {
      command = "${cfg.package}/bin/nufmt";
      includes = [
        "*.nu"
      ];
    };
  };
}
