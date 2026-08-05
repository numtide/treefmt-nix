{
  lib,
  config,
  mkFormatterModule,
  ...
}:
let
  cfg = config.programs.clippy;
in
{
  meta.maintainers = [
    "DigitalBrewStudios/Treefmt-nix"
  ];

  imports = [
    (mkFormatterModule {
      name = "clippy";
      mainProgram = "clippy";
      includes = [ "*.rs" ];
    })
  ];

  options.programs.clippy = {
    denyWarnings = lib.mkEnableOption "clippy to denyWarnings";
    edition = lib.mkOption {
      type = lib.types.str;
      default = "2024";
      description = ''
        Rust edition to target when linting
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.clippy = {
      options = [
        "--edition"
        cfg.edition
      ]
      ++ lib.optionals cfg.denyWarnings [
        "--deny-warnings"
      ];
    };
  };
}
