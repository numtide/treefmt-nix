{
  lib,
  pkgs,
  config,
  mkFormatterModule,
  ...
}:
let
  cfg = config.programs.yamllint;
  settingsFormat = pkgs.formats.yaml { };
in
{
  meta.maintainers = [
    "DigitalBrewStudios/Treefmt-nix"
  ];

  imports = [
    (mkFormatterModule {
      name = "yamllint";
      includes = [
        "*.yaml"
        "*.yml"
      ];
    })
  ];

  options.programs.yamllint = {
    settings = lib.mkOption {
      type = lib.types.submodule { freeformType = settingsFormat.type; };
      default = { };
      description = ''
        Configuration for yamllint, see
        <link xlink:href="https://yamllint.readthedocs.io/en/stable/configuration.html"/>
        for supported values.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.yamllint = {
      options = lib.optional (
        cfg.settings != { }
      ) "-c=${settingsFormat.generate "yamllint.yaml" cfg.settings}";
    };
  };
}
