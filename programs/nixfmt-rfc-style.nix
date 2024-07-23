{ lib, pkgs, config, ... }:
let
  cfg = config.programs.nixfmt-rfc-style;
in
{
  meta.maintainers = [ ];

  options.programs.nixfmt-rfc-style = {
    enable = lib.mkEnableOption "nixfmt-rfc-style";
    package = lib.mkPackageOption pkgs "nixfmt-rfc-style" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.nixfmt-rfc-style = (lib.warn ''
       nixfmt-rfc-style is now the default for the 'nixfmt' formatter.
      'nixfmt-rfc-style' is deprecated and will be removed in the future.
    ''
      {
        command = cfg.package;
        includes = [ "*.nix" ];
      });
  };
}
