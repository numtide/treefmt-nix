{
  lib,
  pkgs,
  config,
  mkFormatterModule,
  ...
}:
let
  cfg = config.programs.nu-lint;
  settingsFormat = pkgs.formats.toml { };
in
{
  meta.maintainers = [ "aldoborrero" ];

  imports = [
    (mkFormatterModule {
      name = "nu-lint";
      includes = [ "*.nu" ];
    })
  ];

  options.programs.nu-lint = {
    fix = lib.mkEnableOption ''
      applying nu-lint's automatic fixes (`--fix`). Without it, nu-lint only
      reports, and fails on violations at `error` level
    '';

    settings = lib.mkOption {
      description = ''
        nu-lint configuration, written to a TOML file passed with `--config`.
        When empty, nu-lint reads `.nu-lint.toml` from the project root.
        See <https://codeberg.org/wvhulle/nu-lint#configuration>.
      '';
      type = settingsFormat.type;
      default = { };
      example = {
        max_pipeline_length = 80;
        groups.performance = "warning";
        rules.dispatch_with_subcommands = "hint";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.nu-lint.options =
      (lib.optional cfg.fix "--fix")
      ++ (lib.optionals (cfg.settings != { }) [
        "--config"
        "${settingsFormat.generate "nu-lint.toml" cfg.settings}"
      ]);
  };
}
