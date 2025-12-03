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
      default = if cfg.useEditorConfig then null else 2;
      example = 4;
      description = ''
        Sets the number of spaces to be used in indentation. Uses tabs if set to
        zero.
      '';
    };

    simplify = lib.mkOption {
      type = lib.types.bool;
      default = !cfg.useEditorConfig;
      description = ''
        Enables the `-s` (`--simplify`) flag, which simplifies code where possible.
      '';
    };

    useEditorConfig = lib.mkEnableOption ''
      Use .editorconfig file for
      formatting. This is mutually exlusive with all other settings. See [shfmt
      docs](https://github.com/mvdan/sh/blob/v3.12.0/cmd/shfmt/shfmt.1.scd?plain=1#L20-L21).
    '';
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.shfmt.options =
      let
        options =
          (lib.optionals (!isNull cfg.indent_size) [
            "-i"
            (toString cfg.indent_size)
          ])
          ++ (lib.optionals (cfg.simplify) [ "-s" ]);
      in
      assert cfg.useEditorConfig -> builtins.length options == 0;
      options;
  };
}
