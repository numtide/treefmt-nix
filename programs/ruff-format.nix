{
  config,
  lib,
  mkFormatterModule,
  ...
}:
let
  cfg = config.programs.ruff-format;
in
{
  meta.maintainers = [ "sebaszv" ];

  imports = [
    (lib.mkRenamedOptionModule
      [ "programs" "ruff" "format" ]
      [
        "programs"
        "ruff-format"
        "enable"
      ]
    )
    (mkFormatterModule {
      name = "ruff-format";
      package = "ruff";
      args = [ "format" ];
      includes = [
        "*.py"
        "*.pyi"
      ];
    })
  ];

  options.programs.ruff-format = {
    lineLength = lib.mkOption {
      description = ''
        Set the line-length.
      '';
      type = with lib.types; nullOr int;
      example = 79;
      default = null;
    };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.ruff-format = {
      options = lib.mkIf (cfg.lineLength != null) [
        "--line-length"
        (toString cfg.lineLength)
      ];
    };
  };
}
