{ lib, pkgs, config, ... }:
let
  cfg = config.programs.mdformat;
in
{
  options.programs.mdformat = {
    enable = lib.mkEnableOption "mdformat";
    package = lib.mkPackageOption pkgs [ "python3Packages" "mdformat" ] { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.mdformat = {
      command = cfg.package;
      includes = [ "*.md" ];
    };
  };
}

