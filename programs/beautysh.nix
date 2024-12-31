{
  lib,
  config,
  mkFormatterModule,
  ...
}:
let
  cfg = config.programs.beautysh;
in
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "beautysh";
      includes = [ "*.sh" ];
    })
  ];

  options.programs.beautysh = {
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
      options = [
        "-i"
        (toString cfg.indent_size)
      ];
    };
  };
}
