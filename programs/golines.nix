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

  config = lib.mkIf cfg.enable {
    settings.formatter.golines = {
      command = "${cfg.package}/bin/golines";
    };
  };
}
