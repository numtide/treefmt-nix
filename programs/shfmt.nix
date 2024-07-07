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
      default = 2;
      example = 4;
      description = ''
        Sets the number of spaces to be used in indentation. Uses tabs if set to
        zero. If this is null, then [.editorconfig will be used to configure
        shfmt](https://github.com/patrickvane/shfmt#description).
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.shfmt = {
      command = cfg.package;
      options =
        (lib.optionals (!isNull cfg.indent_size)
          [ "-i" (toString cfg.indent_size) ])
        ++ [ "-s" "-w" ];
      includes = [ "*.sh" ];
    };
  };
}
