{ lib, pkgs, config, ... }:
let
  cfg = config.programs.nixfmt-classic;
in
{
  meta.maintainers = [ ];

  options.programs.nixfmt-classic = {
    enable = lib.mkEnableOption "nixfmt-classic";
    package = lib.mkPackageOption pkgs "nixfmt-classic" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.nixfmt-classic = (lib.warn ''
      nixfmt-classic is the original flavor of 'nixfmt'.
      This version differs considerably from the new standard and is currently
      unmaintained.
      It has been superseded by 'nixfmt', which conforms to the
      'nixfmt-rfc-style' standard.
    ''
      {
        command = cfg.package;
        includes = [ "*.nix" ];
      });
  };
}
