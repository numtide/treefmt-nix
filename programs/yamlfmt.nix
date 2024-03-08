{ lib, pkgs, config, ... }:
let
  cfg = config.programs.yamlfmt;
  # Run the given program with the given argument (filepath), while expecting
  # the program to *always* write back to the filepath. The program takes
  # -in for alternative input.
  #
  # The resultant script behaves the same except for avoiding writing to file if
  # the output hasn't changed.
  modify-unless-unchanged = pkgs.writeShellScriptBin "modify-unless-unchanged"
    ''
      PROG=$1
      FILEPATH=$2
      OUTPUT=$($PROG -in < "$FILEPATH")
      echo "$OUTPUT" | diff -q "$FILEPATH" - > /dev/null || echo "$OUTPUT" > "$FILEPATH"
    '';
in
{
  options.programs.yamlfmt = {
    enable = lib.mkEnableOption "yamlfmt";
    package = lib.mkPackageOption pkgs "yamlfmt" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.yamlfmt = {
      command = pkgs.writeShellApplication {
        name = "yamlfmt-forall";
        runtimeInputs = [
          cfg.package
          modify-unless-unchanged
        ];
        text = ''
          for file in "$@"; do
            # Use the modify-unless-unchanged hack until this is implemented:
            # https://github.com/google/yamlfmt/issues/163
            modify-unless-unchanged yamlfmt "$file"
          done
        '';
      };
      includes = [ "*.yaml" "*.yml" ];
    };
  };
}
