{
  lib,
  config,
  mkFormatterModule,
  ...
}:
let
  cfg = config.programs.gofumpt;
in
{
  meta.maintainers = [ "zimbatm" ];

  imports = [
    (mkFormatterModule {
      name = "gofumpt";
      args = [ "-w" ];
      includes = [ "*.go" ];
      excludes = [ "vendor/*" ];
    })
  ];

  options.programs.gofumpt = {
    extra = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to enable extra rules.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.gofumpt = {
      options = lib.optional cfg.extra "-extra";
    };
  };
}
