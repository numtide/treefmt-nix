{
  lib,
  pkgs,
  config,
  mkFormatterModule,
  ...
}:
let
  cfg = config.programs.packer;

  # `packer fmt` accepts only a single template as an argument:
  # > $ packer fmt -h |& head -n 1
  # > Usage: packer fmt [options] [TEMPLATE]
  # `packer fmt` supports recursively formatting all `*.pkr.hcl` and
  # `*.pkrvars.hcl` files in a specified directory, but since we want to
  # control the exact list of files-to-be-formatted, we instead have to invoke
  # `packer fmt` once per selected file.  Consequently, we need a means of
  # distinguishing which arguments are options (from
  # `settings.formatter.packer.options`) and which are filenames; this is so
  # that we can pass all options to each `packer fmt`.  The traditional `--`
  # sequence suits this purpose.
  command = pkgs.writers.writeBashBin "treefmt-nix-packer-fmt-wrapper" ''
      set -eu

      declare -a opts
      saw_separator=0
      while (( "$#" > 0 )); do
        if [[ "$1" = -- ]]; then
          saw_separator=1
          shift
          break
        fi

        opts+=("$1")
        shift
      done

      if [[ "$saw_separator" = 0 ]]; then
        echo 1>&2 "\
    Error: ''${0##*/}: the end-of-options separator sequence is missing.
    Please ensure that the final entry in 'settings.formatter.packer.options' is a bare double-dash ('--').
    Otherwise, this program cannot determine which arguments are options to 'packer fmt' and which are filenames."
        exit 1
      fi

      rc=0
      for tmpl in "$@"; do
        ${lib.escapeShellArg cfg.package}/bin/packer fmt "''${opts[@]}" "$tmpl" || rc="$?"
      done

      exit "''${rc:-0}"
  '';
in
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "packer";
      includes = [
        "*.pkr.hcl"
        "*.pkrvars.hcl"
      ];
    })
  ];

  config = lib.mkIf cfg.enable {
    settings.formatter.packer = {
      inherit command;
      options = lib.mkAfter [ "--" ];
    };
  };
}
