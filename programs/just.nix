{
  lib,
  pkgs,
  config,
  mkFormatterModule,
  ...
}:
let
  # Search 'justfile' in subdirectories too. This isn't needed for filename starting with `*.`.
  alsoSearchSubdirectory = lib.lists.concatMap (fileName: [ fileName ] ++ [ "*/${fileName}" ]);
  cfg = config.programs.just;
in
{
  meta.maintainers = [ "katexochen" ];
  # Example contains store paths
  meta.skipExample = true;

  imports = [
    (mkFormatterModule {
      name = "just";
      includes =
        alsoSearchSubdirectory [
          "[Jj][Uu][Ss][Tt][Ff][Ii][Ll][Ee]" # 'justfile', case insensitive
          ".[Jj][Uu][Ss][Tt][Ff][Ii][Ll][Ee]" # '.justfile', case insensitive
        ]
        ++ [
          "*.[Jj][Uu][Ss][Tt]" # '.just' module, case insensitive
          "*.[Jj][Uu][Ss][Tt][Ff][Ii][Ll][Ee]" # '.justfile' module, case insensitive
        ];
    })
  ];

  options.programs.just = {
    indentation = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "  ";
      description = ''
        Indentation to use for recipe bodies.
        Requires just >= 1.49.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.just = {
      # just itself doesn't comply with the treefmt spec, as the --justfile flags expects a single argument
      # the spec requires the formatter to accept multiple file names as arguments (see https://treefmt.com/latest/reference/formatter-spec/#1-files-passed-as-arguments).
      command = pkgs.bash;
      options = [
        "-euc"
        (
          let
            indentation = lib.optionals (cfg.indentation != null) [
              "--indentation"
              cfg.indentation
            ];
          in
          ''
            for f in "$@"; do
              ${lib.getExe cfg.package} --fmt --unstable ${lib.escapeShellArgs indentation} --justfile "$f"
            done
          ''
        )
        "--" # bash swallows the second argument when using -c
      ];
    };
  };
}
