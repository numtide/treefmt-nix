{
  lib,
  pkgs,
  config,
  mkFormatterModule,
  ...
}:
let
  cfg = config.programs.nu-check;

  # `nu-check` is a Nushell builtin, not a binary, so it runs inside a one-file `nu`
  # script; treefmt calls it once per file (no-positional-arg-support below).
  #
  # Inside a script, `nu-check` resolves a relative path against the script's own
  # directory (here, the store), not the working directory treefmt runs from, so the
  # path is made absolute against $env.PWD first.
  check = "nu-check ${lib.optionalString cfg.as-module "--as-module "}";
  script = pkgs.writeText "nu_check.nu" ''
    # Parse-check the file treefmt passes; exit 1 if it does not parse.
    def main [file: string] {
      let absolute = $env.PWD | path join $file
      if not ($absolute | path exists) {
        print --stderr $"($file): no such file"
        exit 1
      }
      if not (${check}$absolute) {
        # Report it with nu's own diagnostic. A child process gets the path as a
        # literal, so the diagnostic names the file rather than the expression
        # that computed it.
        do --ignore-errors {
          ^$nu.current-exe --no-config-file --commands $"${check}--debug ($absolute | to nuon) | ignore"
        }
        exit 1
      }
    }
  '';
in
{
  meta.maintainers = [ "aldoborrero" ];

  imports = [
    (mkFormatterModule {
      name = "nu-check";
      package = "nushell";
      includes = [ "*.nu" ];
    })
  ];

  options.programs.nu-check = {
    as-module = lib.mkEnableOption "parsing every file as a module (`nu-check --as-module`)";
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.nu-check = {
      command = lib.getExe cfg.package;
      options = [
        "--no-config-file"
        "${script}"
      ];
      # `nu-check` takes a single path.
      no-positional-arg-support = true;
    };
  };
}
