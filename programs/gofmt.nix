{
  config,
  lib,
  mkFormatterModule,
  ...
}:
let
  cfg = config.programs.gofmt;
in
{
  meta.maintainers = [ "zimbatm" ];

  imports = [
    (mkFormatterModule {
      name = "gofmt";
      # It would be nice to extract gofmt to its own package
      package = "go";
      args = [ "-w" ];
      includes = [ "*.go" ];
      excludes = [ "vendor/*" ];
    })
  ];

  config = lib.mkIf cfg.enable {
    settings.formatter.gofmt = {
      command = "${cfg.package}/bin/gofmt";
    };
  };
}
