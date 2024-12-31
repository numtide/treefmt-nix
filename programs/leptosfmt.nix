{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.programs.leptosfmt;
in
{
  meta.maintainers = [ ];

  options.programs.leptosfmt = {
    enable = lib.mkEnableOption "leptosfmt";
    package = lib.mkPackageOption pkgs "leptosfmt" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.leptosfmt = {
      command = "${cfg.package}/bin/leptosfmt";
      includes = [ "*.rs" ];
    };
  };
}
