{ lib, pkgs, config, ... }:
let
  cfg = config.programs.beautysh;
in
{
  options.programs.beautysh = {
    enable = lib.mkEnableOption "beautysh";
    package = lib.mkPackageOption pkgs "beautysh" { };
    indent_size = lib.mkOption {
      type = lib.types.int;
      default = 2;
      example = 4;
      description = ''
        Sets the number of spaces to be used in indentation.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.beautysh = {
      command = cfg.package;
      options = [ "-i" (toString cfg.indent_size) ];
      includes = [ "*.sh" ];
    };
  };
}
