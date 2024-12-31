{
  lib,
  config,
  mkFormatterModule,
  ...
}:
let
  cfg = config.programs.isort;
in
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "isort";
      includes = [
        "*.py"
        "*.pyi"
      ];
    })
  ];

  options.programs.isort = {
    profile = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = ''
        The profile to use for isort.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.isort.options = lib.optionals (cfg.profile != "") [
      "--profile"
      cfg.profile
    ];
  };
}
