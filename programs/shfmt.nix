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
  meta.brokenPlatforms = [ "riscv64-linux" ];

  imports = [
    (mkFormatterModule {
      name = "shfmt";
      args = [ "-w" ];
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
      default = null;
      example = 4;
      description = ''
        Sets the number of spaces to be used in indentation. Uses tabs if set to
        zero.
      '';
    };

    simplify = lib.mkEnableOption "the `-s` (`--simplify`) flag, which simplifies code where possible";

    useEditorConfig = lib.mkEnableOption "" // {
      description = ''
        Whether to use {file}`.editorconfig` for
        formatting. This is mutually exlusive with all other settings. See [shfmt
        docs](https://github.com/mvdan/sh/blob/v3.12.0/cmd/shfmt/shfmt.1.scd?plain=1#L20-L21).
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.shfmt.options =
      assert cfg.useEditorConfig -> builtins.length config.settings.formatter.shfmt.options == 0;
      lib.optionals (cfg.indent_size != null) [
        "-i"
        (toString cfg.indent_size)
      ]
      ++ lib.optional (cfg.simplify) "-s";
  };
}
