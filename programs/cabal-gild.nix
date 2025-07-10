{
  lib,
  config,
  pkgs,
  mkFormatterModule,
  ...
}:

let
  cfg = config.programs.cabal-gild;
in
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "cabal-gild";
      package = [
        "haskellPackages"
        "cabal-gild"
      ];
      includes = [
        "*.cabal"
        "cabal.project"
        "cabal.project.local"
        # Include Haskell source files to detect changes
        # for cabal-gild's module discovery feature
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
    settings.formatter.cabal-gild = {
      # cabal-gild doesn't support multiple file targets
      # https://github.com/tfausak/cabal-gild/issues/35
      command = pkgs.writeShellApplication {
        name = "cabal-gild-wrapper";
        text = ''
          for file in "$@"; do
            # Only process .cabal files and cabal.project files
            case "$file" in
              *.cabal|cabal.project|cabal.project.local)
                ${lib.getExe cfg.package} --io="$file"
                ;;
              *)
                # Skip non-cabal files (e.g., .hs files)
                ;;
            esac
          done
        '';
      };
    };
  };
}
