{
  lib,
  pkgs,
  config,
  mkFormatterModule,
  ...
}:

let
  cfg = config.programs.pinact;

  settingsFormat = pkgs.formats.yaml { };
in

{
  meta.maintainers = [ "katexochen" ];

  imports = [
    (mkFormatterModule {
      name = "pinact";
      args = [ "run" ];
      includes = [
        ".github/workflows/*.yml"
        ".github/workflows/*.yaml"
        "**/action.yml"
        "**/action.yaml"
      ];
    })
  ];

  options.programs.pinact = {
    update = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Update actions to latest versions.";
    };
    verify = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Verify if pairs of commit SHA and version are correct.";
    };
    settings = lib.mkOption {
      type = lib.types.submodule { freeformType = settingsFormat.type; };
      default = { };
      description = ''
        Configuration for pinact, see
        <link xlink:href="https://github.com/suzuki-shunsuke/pinact?tab=readme-ov-file#configuration"/>
        for supported values.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.pinact = {
      options =
        lib.optional (cfg.settings != { }) "--config=${settingsFormat.generate "pinact.yaml" cfg.settings}"
        ++ lib.optional (cfg.update) "--update"
        ++ lib.optional (cfg.verify) "--verify";

    };
  };
}
