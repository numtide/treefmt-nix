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

  config = lib.mkIf cfg.enable {
    settings.formatter.just = {
      # just itself doesn't comply with the treefmt spec, as the --justfile flags expects a single argument
      # the spec requires the formatter to accept multiple file names as arguments (see https://treefmt.com/latest/reference/formatter-spec/#1-files-passed-as-arguments).
      command = pkgs.bash;
      options = [
        "-euc"
        ''
          for f in "$@"; do
            ${lib.getExe cfg.package} --fmt --unstable --justfile "$f"
          done
        ''
        "--" # bash swallows the second argument when using -c
      ];
    };
  };
}
