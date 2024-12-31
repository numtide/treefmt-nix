{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.programs.nimpretty;
in
{
  meta.maintainers = [ ];

  options.programs.nimpretty = {
    enable = lib.mkEnableOption "nimpretty";
    package = lib.mkPackageOption pkgs "nim" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.nimpretty = {
      command = "${cfg.package}/bin/nimpretty";
      includes = [ "*.nim" ];
    };
  };
}
