{
  lib,
  config,
  mkFormatterModule,
  ...
}:
let
  cfg = config.programs.jsonnet-lint;
in
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "jsonnet-lint";
      package = "go-jsonnet";
      includes = [
        "*.jsonnet"
        "*.libsonnet"
      ];
    })
  ];

  config = lib.mkIf cfg.enable {
    settings.formatter.jsonnet-lint = {
      command = "${cfg.package}/bin/jsonnet-lint";
    };
  };
}
