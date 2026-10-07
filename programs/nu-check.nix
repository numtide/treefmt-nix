{
  lib,
  pkgs,
  config,
  mkFormatterModule,
  ...
}:
let
  cfg = config.programs.nu-check;

  # `nu-check` is a Nushell builtin, not a binary, and takes a single path: run it
  # once per file inside one `nu` process and fail if any file does not parse.
  #
  # Inside a script, `nu-check` resolves a relative path against the script's own
  # directory (here, the store), not the working directory treefmt runs from, so
  # every path is made absolute against $env.PWD first.
  script = pkgs.writeText "nu_check.nu" ''
    # Parse-check every file treefmt passes; exit 1 if any of them does not parse.
    def main [...files: string] {
      let failed = $files | where { |file|
        let absolute = $env.PWD | path join $file
        if not ($absolute | path exists) {
          print --stderr $"($file): no such file"
          return true
        }
        not (nu-check ${lib.optionalString cfg.as-module "--as-module "}$absolute)
      }
      # Report each failure with nu's own diagnostic. A child process gets the path
      # as a literal, so the diagnostic names the file rather than the expression
      # that computed it.
      for file in $failed {
        let absolute = $env.PWD | path join $file | to nuon
        do --ignore-errors {
          ^$nu.current-exe --no-config-file --commands $"nu-check ${lib.optionalString cfg.as-module "--as-module "}--debug ($absolute) | ignore"
        }
      }
      if ($failed | is-not-empty) { exit 1 }
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
    };
  };
}
