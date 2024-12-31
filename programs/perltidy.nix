{
  lib,
  config,
  mkFormatterModule,
  ...
}:
let
  cfg = config.programs.perltidy;
in
{
  meta.maintainers = [ "haruki7049" ];

  imports = [
    (mkFormatterModule {
      name = "perltidy";
      package = [
        "perlPackages"
        "PerlTidy"
      ];
      args = [
        "-b"
        "-bext='/'"
      ];
      includes = [ "*.pl" ];
    })
  ];

  options.programs.perltidy = {
    perltidyrc = lib.mkOption {
      description = "A path for perltidy's configuration file, usually named .perltidyrc";
      type = lib.types.nullOr lib.types.path;
      default = null;
    };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.perltidy = {
      options = lib.optional (cfg.perltidyrc != null) "-pro=${cfg.perltidyrc}";
    };
  };
}
