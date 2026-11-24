{
  lib,
  pkgs,
  config,
  mkFormatterModule,
  ...
}:
let
  cfg = config.programs.nu-check;

  # `nu-check` is a Nushell builtin, not a binary, so it runs inside a script.
  script = pkgs.writeText "nu_check.nu" ''
    # Fail if the file is not valid Nushell: with --debug, nu-check prints the
    # parse error and raises instead of returning false.
    def main [file: string] {
      # nu-check resolves a relative path against the running script's directory
      # ($env.FILE_PWD, here the store), not the directory treefmt runs in.
      nu-check ${lib.optionalString cfg.as-module "--as-module "}--debug ($file | path expand)
    }
  '';
in
{
  meta.maintainers = [ "aldoborrero" ];

  imports = [
    (mkFormatterModule {
      name = "nu-check";
      package = "nushell";
      args = [
        "--no-config-file"
        "${script}"
      ];
      includes = [ "*.nu" ];
    })
  ];

  options.programs.nu-check.as-module = lib.mkEnableOption "parsing every file as a module (`nu-check --as-module`)";

  config = lib.mkIf cfg.enable {
    # The script checks one file per run.
    settings.formatter.nu-check.no-positional-arg-support = true;
  };
}
