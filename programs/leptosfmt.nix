{ lib, pkgs, config, ... }:
let
  cfg = config.programs.leptosfmt;
  # Run the given program with the given argument (filepath), while expecting
  # the program to *always* write back to the filepath. The program takes
  # --stdin for alternative input.
  #
  # The resultant script behaves the same except for avoiding writing to file if
  # the output hasn't changed.
  modify-unless-unchanged = pkgs.writeShellScriptBin "modify-unless-unchanged"
    ''
      PROG=$1
      FILEPATH=$2
      OUTPUT=$($PROG --stdin < "$FILEPATH")
      echo "$OUTPUT" | diff -q "$FILEPATH" - > /dev/null || echo "$OUTPUT" > "$FILEPATH"
    '';
in
{
  options.programs.leptosfmt = {
    enable = lib.mkEnableOption "leptosfmt";
    package = lib.mkPackageOption pkgs "leptosfmt" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.leptosfmt = {
      command = pkgs.writeShellApplication {
        name = "leptosfmt-forall";
        runtimeInputs = [
          cfg.package
          modify-unless-unchanged
        ];
        text = ''
          # leptosfmt doesn't take multiple arguments yet
          # https://github.com/bram209/leptosfmt/issues/63
          for file in "$@"; do
            # Use the modify-unless-unchanged hack until this is implemented:
            # https://github.com/bram209/leptosfmt/issues/64
            modify-unless-unchanged leptosfmt "$file"
          done
        '';
      };
      includes = [ "*.rs" ];
    };
  };
}
