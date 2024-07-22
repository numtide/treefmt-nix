{ lib, pkgs, config, ... }:
let
  cfg = config.programs.stylish-haskell;
in
{
  meta.maintainers = [ ];

  options.programs.stylish-haskell = {
    enable = lib.mkEnableOption "stylish-haskell";
    package = lib.mkPackageOption pkgs "stylish-haskell" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.stylish-haskell = {
      command = cfg.package;
      options = [ "-i" "-r" ];
      includes = [ "*.hs" ];
    };
  };
}
