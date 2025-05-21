{
  config,
  lib,
  mkFormatterModule,
  ...
}:
let
  cfg = config.programs.rstfmt;
in
{
  meta.maintainers = [ "rbpatt2019" ];

  imports = [
    (mkFormatterModule {
      name = "rstfmt";
      includes = [
        "*.rst"
        "*.txt"
      ];
    })
  ];

  options.programs.rstfmt = {
    line_length = lib.mkOption {
      type = lib.types.int;
      default = 72;
      example = 80;
      description = ''
        Sets the line length.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.rstfmt = {
      options = [
        "-w"
        (toString cfg.line_length)
      ];
    };
  };
}
