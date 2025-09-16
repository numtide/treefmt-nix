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
        # The cabal file needs to be formatted by a formatter along with other Haskell source code.
        # For example, module completion by `cabal-gild: discover`.
        # It is difficult to determine this strictly.
        # Since formatting with cabal-gild doesn't take much time, we execute it speculatively.
        text = ''${pkgs.git}/bin/git ls-files -z "*.cabal"|${pkgs.parallel}/bin/parallel --null "${lib.getExe cfg.package} --io {}"'';
      };
    };
  };
}
