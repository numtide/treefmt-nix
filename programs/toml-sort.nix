{
  lib,
  config,
  mkFormatterModule,
  ...
}:
let
  cfg = config.programs.toml-sort;
in
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "toml-sort";
      args = [ "-i" ];
      includes = [ "*.toml" ];
    })
  ];

  options.programs.toml-sort = {
    all = lib.mkEnableOption "sort ALL keys";
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.toml-sort = {
      options = lib.optional cfg.all "--all";
    };
  };
}
