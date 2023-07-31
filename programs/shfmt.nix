{ lib, pkgs, config, ... }:
let
  cfg = config.programs.shfmt;
in
{
  options.programs.shfmt = {
    enable = lib.mkEnableOption "shfmt";
    package = lib.mkPackageOption pkgs "shfmt" { };
    indent_size = lib.mkOption {
      type = lib.types.nullOr lib.types.int;
      default = null;
      example = 4;
      description = lib.mdDoc ''
        Sets the number of spaces to be used in indentation. Uses tabs if set to zero.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.shfmt = {
      command = cfg.package;
      options =
        (if isNull cfg.indent_size
        then [ ]
        else [ "-i" (toString cfg.indent_size) ])
        ++ [ "-s" "-w" ];
      includes = [ "*.sh" ];
    };
  };
}
