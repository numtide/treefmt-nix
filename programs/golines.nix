{
  lib,
  config,
  mkFormatterModule,
  ...
}:
let
  cfg = config.programs.golines;
in
{
  meta.maintainers = [ "gabyx" ];

  imports = [
    (mkFormatterModule {
      name = "golines";
      package = "golines";
      args = [
        "-w"
        # Do not reformat tags due to destructive operations:
        # See https://github.com/segmentio/golines/issues/161
        "--no-reformat-tags"
      ];
      includes = [ "*.go" ];
      excludes = [ "vendor/*" ];
    })
  ];

  options.programs.golines = {
    maxLength = lib.mkOption {
      type = with lib.types; nullOr int;
      default = null;
      example = 100;
      description = ''
        Target maximum line length (default: 100)
      '';
    };

    tabLength = lib.mkOption {
      type = with lib.types; nullOr int;
      default = null;
      example = 4;
      description = ''
        Length of a tab (default: 4).
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.golines = {
      command = "${cfg.package}/bin/golines";
    };
  };
}
