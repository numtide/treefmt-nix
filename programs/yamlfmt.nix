{
  lib,
  pkgs,
  config,
  mkFormatterModule,
  ...
}:
let
  cfg = config.programs.yamlfmt;

  settingsFormat = pkgs.formats.yaml { };
in
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "yamlfmt";
      includes = [
        "*.yaml"
        "*.yml"
      ];
    })
  ];

  options.programs.yamlfmt = {
    settings = lib.mkOption {
      type = lib.types.submodule { freeformType = settingsFormat.type; };
      default = { };
      description = ''
        Configuration for yamlfmt, see
        <link xlink:href="https://github.com/google/yamlfmt/blob/main/docs/config-file.md"/>
        for supported values.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.yamlfmt = {
      options = lib.optional (
        cfg.settings != { }
      ) "-conf=${settingsFormat.generate "yamlfmt.conf" cfg.settings}";
    };
  };
}
