{ lib, pkgs, config, ... }:
let
  cfg = config.programs.rubocop;
in
{
  meta.maintainers = [ ];

  options.programs.rubocop = {
    enable = lib.mkEnableOption "rubocop";
    package = lib.mkPackageOption pkgs "rubocop" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.rubocop = {
      command = cfg.package;
      includes = [ "*.rb" ];
    };
  };
}
