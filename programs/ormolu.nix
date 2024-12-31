{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.programs.ormolu;
in
{
  meta.maintainers = [ ];

  options.programs.ormolu = {
    enable = lib.mkEnableOption "ormolu";
    package = lib.mkPackageOption pkgs "ormolu" { };
    ghcOpts = lib.mkOption {
      description = "Which GHC language extensions to enable";
      default = [
        "BangPatterns"
        "PatternSynonyms"
        "TypeApplications"
      ];
    };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.ormolu = {
      command = cfg.package;
      options =
        [
          "--mode"
          "inplace"
          "--check-idempotence"
        ]
        ++ (lib.concatMap (x: [
          "--ghc-opt"
          "-X${x}"
        ]) cfg.ghcOpts);
      includes = [ "*.hs" ];
    };
  };
}
