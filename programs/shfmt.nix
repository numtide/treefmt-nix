{
  config,
  lib,
  mkFormatterModule,
  ...
}:
let
  cfg = config.programs.shfmt;
in
{
  meta.maintainers = [
    "zimbatm"
    "katexochen"
  ];

  imports = [
    (mkFormatterModule {
      name = "shfmt";
      args = [
        "-s"
        "-w"
      ];
      includes = [
        "*.sh"
        "*.bash"
        # direnv
        "*.envrc"
        "*.envrc.*"
      ];
    })
  ];

  options.programs.shfmt = {
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
    settings.formatter.shfmt.options = lib.optionals (!isNull cfg.indent_size) [
      "-i"
      (toString cfg.indent_size)
    ];
  };
}
