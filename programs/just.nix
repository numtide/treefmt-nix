{ lib, pkgs, config, ... }:
let
  cfg = config.programs.just;
in
{
  meta.maintainers = [ ];

  options.programs.just = {
    enable = lib.mkEnableOption "just";
    package = lib.mkPackageOption pkgs "just" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.just = {
      command = pkgs.bash;
      options = [
        "-euc"
        ''
          for f in "$@"; do
            ${lib.getExe' cfg.package "just"} --fmt --unstable --justfile "$f"
          done
        ''
        "--" # bash swallows the second argument when using -c
      ];
      includes = [
        "[Jj][Uu][Ss][Tt][Ff][Ii][Ll][Ee]" # 'justfile', case insensitive
      ];
    };
  };
}
