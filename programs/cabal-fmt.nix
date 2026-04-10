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
        # The cabal file needs to be formatted by a formatter along with other Haskell source code.
        # For example, module completion by `cabal-fmt: discover`.
        # It is difficult to determine this strictly.
        # Since formatting with cabal-fmt doesn't take much time, we execute it speculatively.
        text = ''${pkgs.git}/bin/git ls-files -z "*.cabal"|${pkgs.parallel}/bin/parallel --null "${lib.getExe cfg.package} --inplace {}"'';
      };
      # Clear args since we're handling them in the wrapper
      options = lib.mkForce [ ];
    };
  };
}
