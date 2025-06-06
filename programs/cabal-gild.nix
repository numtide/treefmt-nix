{
  mkFormatterModule,
  lib,
  config,
  pkgs,
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
            ${lib.getExe cfg.package} --io="$file"
          done
        '';
      };
    };
  };
}
