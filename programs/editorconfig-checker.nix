{
  lib,
  config,
  mkFormatterModule,
  ...
}:
let
  cfg = config.programs.editorconfig-checker;

  # editorconfig-checker uses Go's `flag` package, so flags take a single dash
  # and values are passed as separate arguments.
  toEditorconfigCheckerArgs = lib.cli.toCommandLine (name: {
    option = "-${name}";
    sep = null;
    explicitBool = false;
  });
in
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "editorconfig-checker";
      package = "editorconfig-checker";
      includes = [ "*" ];
    })
  ];

  options.programs.editorconfig-checker = {
    flags = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.nullOr (
          lib.types.oneOf [
            lib.types.bool
            lib.types.str
          ]
        )
      );
      default = { };
      example = {
        config = ".editorconfig-checker.json";
        format = "github-actions";
        disable-max-line-length = true;
      };
      description = ''
        Command line flags passed to editorconfig-checker.
        Each attribute name is converted to a single-dash flag (e.g. `disable-charset` becomes `-disable-charset`).
        `true` passes the flag without a value, `false` and `null` omit it,
        and a string is passed as the flag's value.
        Run `editorconfig-checker -help` to see the available flags.
      '';
    };
  };

  # editorconfig-checker only reports violations and does not modify files.
  # Since v4.0.0 it supports `-fix`, which automatically fixes
  # `trim_trailing_whitespace`, `end_of_line` and `insert_final_newline` violations.
  # We do not pass it by default because the nixpkgs we follow still ships v3,
  # where the flag does not exist.
  config = lib.mkIf cfg.enable {
    settings.formatter.editorconfig-checker.options = toEditorconfigCheckerArgs cfg.flags;
  };
}
