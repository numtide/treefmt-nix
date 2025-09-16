{
  lib,
  config,
  pkgs,
  mkFormatterModule,
  ...
}:
let
  cfg = config.programs.cabal-fmt;
in
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "cabal-fmt";
      package = [
        "haskellPackages"
        "cabal-fmt"
      ];
      includes = [
        "*.cabal"
        # Include Haskell source files to detect changes
        # for cabal-fmt's module discovery feature
        "*.chs"
        "*.cpphs"
        "*.gc"
        "*.hs"
        "*.hsc"
        "*.hsig"
        "*.lhs"
        "*.lhsig"
        "*.ly"
        "*.x"
        "*.y"
      ];
    })
  ];

  config = lib.mkIf cfg.enable {
    settings.formatter.cabal-fmt = {
      # Override command to filter out non-cabal files
      command = pkgs.writeShellApplication {
        name = "cabal-fmt-wrapper";
        text = ''
          cabal_files=()
          for file in "$@"; do
            # Only process .cabal files
            case "$file" in
              *.cabal)
                cabal_files+=("$file")
                ;;
              *)
                # Skip non-cabal files (e.g., .hs files)
                ;;
            esac
          done

          if [ ''${#cabal_files[@]} -gt 0 ]; then
            ${lib.getExe cfg.package} --inplace "''${cabal_files[@]}"
          fi
        '';
      };
      # Clear args since we're handling them in the wrapper
      options = lib.mkForce [ ];
    };
  };
}
