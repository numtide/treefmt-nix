{
  lib,
  pkgs,
  config,
  mkFormatterModule,
  ...
}:
let
  cfg = config.programs.json-sort-cli;
in
{
  meta = {
    # Example contains store paths
    skipExample = true;
    maintainers = [ ];
  };

  imports = [
    (mkFormatterModule {
      name = "json-sort-cli";
      package = "json-sort-cli";
      mainProgram = "json-sort";
      includes = [
        "*.json"
      ];
    })
  ];

  options.programs.json-sort-cli = {
    autofix = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Update files with fixes instead of just reporting.
        Defaults to `false`.
      '';
    };

    insert-final-newline = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Insert a final newline after the sort. Defaults to `false`.
        Overrides `.editorconfig` settings if an `.editorconfig` is found.
      '';
    };

    end-of-line = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "lf"
          "crlf"
          "cr"
          "unset"
        ]
      );
      default = null;
      description = ''
        Specify the desired line ending for output.
        Defaults to system line ending.
        Overrides `.editorconfig` settings if an `.editorconfig` is found.
      '';
    };

    indent-style = lib.mkOption {
      type = lib.types.enum [
        "space"
        "tab"
      ];
      default = "space";
      description = ''
        Specify the desired indentation style for output.
        Defaults to `space`. Overrides `.editorconfig` settings if an `.editorconfig` is found.
      '';
    };

    indent-size = lib.mkOption {
      type = lib.types.int;
      default = 2;
      description = ''
        Number of spaces to indent, or the string "tab" to use tabs.
        Defaults to 2 spaces. Overrides `.editorconfig` settings if an `.editorconfig` is found.
      '';
    };

  };

  config = lib.mkIf cfg.enable {
    settings.formatter.json-sort-cli = {
      command = pkgs.bash;
      options = [
        "-euc"
        (
          ''
            for f in "$@"; do
              ${lib.getExe cfg.package} $f \
                --autofix ${if cfg.autofix == true then "true" else "false"} \
                --insert-final-newline ${if cfg.insert-final-newline == true then "true" else "false"} \
          ''
          + (lib.optionalString (cfg.end-of-line != null) "--end-of-line ${cfg.end-of-line}")
          + ''
            \
              --indent-style ${cfg.indent-style} \
              --indent-size ${toString cfg.indent-size} || true
            done
          ''
        )
        "--"
      ];
    };
  };
}
