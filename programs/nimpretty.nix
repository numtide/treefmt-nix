{
  lib,
  config,
  mkFormatterModule,
  ...
}:
let
  cfg = config.programs.nimpretty;
in
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "nimpretty";
      package = "nim";
      includes = [ "*.nim" ];
    })
  ];

  config = lib.mkIf cfg.enable {
    settings.formatter.nimpretty = {
      command = "${cfg.package}/bin/nimpretty";
    };
  };
}
