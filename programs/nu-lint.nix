{
  lib,
  pkgs,
  config,
  mkFormatterModule,
  ...
}:
let
  cfg = config.programs.nu-lint;
  configFormat = pkgs.formats.toml { };
in
{
  meta.maintainers = [ "aldoborrero" ];

  imports = [
    (mkFormatterModule {
      name = "nu-lint";
      includes = [ "*.nu" ];
    })
  ];

  options.programs.nu-lint.settings = lib.mkOption {
    description = ''
      nu-lint configuration, written to a TOML file and passed with `--config`.
      See <https://codeberg.org/wvhulle/nu-lint#configuration>.
    '';
    type = lib.types.submodule { freeformType = configFormat.type; };
    default = { };
    example = {
      max_pipeline_length = 80;
      groups.performance = "warning";
      rules.dispatch_with_subcommands = "hint";
    };
  };

  config = lib.mkIf cfg.enable {
    # Always pass a config file, even an empty one: without `--config`, nu-lint
    # reads the user's ~/.config/nu-lint.toml, so results would vary by machine.
    settings.formatter.nu-lint.options = [
      "--config"
      "${configFormat.generate "nu_lint.toml" cfg.settings}"
    ];
  };
}
