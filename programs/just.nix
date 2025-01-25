{
  lib,
  pkgs,
  config,
  mkFormatterModule,
  ...
}:
let
  cfg = config.programs.just;
in
{
  meta.maintainers = [ "katexochen" ];

  imports = [
    (mkFormatterModule {
      name = "just";
      includes = [
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
