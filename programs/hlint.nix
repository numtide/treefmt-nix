{ lib, pkgs, config, ... }:
let
  cfg = config.programs.hlint;
in
{
  options.programs.hlint = {
    enable = lib.mkEnableOption "hlint";
    package = lib.mkPackageOption pkgs "hlint" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.hlint = {
      command = "${lib.getBin cfg.package}/bin/hlint";
      options = [ "-j" ];
      includes = [ "*.hs" ];
    };
  };
}

