{
  lib,
  config,
  mkFormatterModule,
  ...
}:
let
  cfg = config.programs.rustfmt;
in
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "rustfmt";
      mainProgram = "rustfmt";
      args = [
        "--config"
        "skip_children=true"
      ];
      includes = [ "*.rs" ];
    })
  ];

  options.programs.rustfmt = {
    edition = lib.mkOption {
      type = lib.types.str;
      default = "2021";
      description = ''
        Rust edition to target when formatting
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.rustfmt = {
      options = [
        "--edition"
        cfg.edition
      ];
    };
  };
}
