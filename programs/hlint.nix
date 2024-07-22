{ lib, pkgs, config, ... }:
let
  cfg = config.programs.hlint;
in
{
  meta.maintainers = [ ];

  options.programs.hlint = {
    enable = lib.mkEnableOption "hlint";
    package = lib.mkPackageOption pkgs "hlint" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.hlint = {
      command = cfg.package;
      options = [ "-j" ];
      includes = [ "*.hs" ];
    };
  };
}

