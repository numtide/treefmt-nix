{ lib, pkgs, config, ... }:
let
  cfg = config.programs.keep-sorted;
in
{
  options.programs.keep-sorted = {
    enable = lib.mkEnableOption "keep-sorted";
    package = lib.mkPackageOption pkgs "keep-sorted" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.keep-sorted = {
      command = cfg.package;
      includes = [ "*" ];
    };
  };
}
