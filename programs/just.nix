{
  lib,
  pkgs,
  config,
  mkFormatterModule,
  ...
}:
let
  cfg = config.programs.just;
  # Search 'justfile' in subdirectories
  addSubdirectory = lib.lists.concatMap (fileName: [ fileName ] ++ [ "*/${fileName}" ]);
in
{
  meta.maintainers = [ "katexochen" ];

  imports = [
    (mkFormatterModule {
      name = "just";
      includes = addSubdirectory [
        "[Jj][Uu][Ss][Tt][Ff][Ii][Ll][Ee]" # 'justfile', case insensitive
        ".[Jj][Uu][Ss][Tt][Ff][Ii][Ll][Ee]" # '.justfile', case insensitive
        "*.[Jj][Uu][Ss][Tt]" # '.just' module, case insensitive
        "*.[Jj][Uu][Ss][Tt][Ff][Ii][Ll][Ee]" # '.justfile' module, case insensitive
      ];
    })
  ];

  config = lib.mkIf cfg.enable {
    settings.formatter.just = {
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
