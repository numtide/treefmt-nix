{ lib, pkgs, config, ... }:
let
  cfg = config.programs.nixfmt-rfc-style;
in
{
  options.programs.nixfmt-rfc-style = {
    enable = lib.mkEnableOption "nixfmt-rfc-style";
    package = lib.mkPackageOption pkgs "nixfmt-rfc-style" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.nixfmt-rfc-style = {
      command = cfg.package;
      includes = [ "*.nix" ];
    };
  };
}
