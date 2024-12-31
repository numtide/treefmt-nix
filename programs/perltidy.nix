{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.programs.perltidy;
in
{
  meta.maintainers = [ "haruki7049" ];

  options.programs.perltidy = {
    enable = lib.mkEnableOption "perltidy";
    package = lib.mkPackageOption pkgs.perlPackages "PerlTidy" { };

    options = lib.mkOption {
      description = "Options for perltidy";
      type = lib.types.listOf lib.types.str;
      default = [
        "-b"
        "-bext='/'"
      ];
    };

    perltidyrc = lib.mkOption {
      description = "A path for perltidy's configuration file, usually named .perltidyrc";
      type = lib.types.nullOr lib.types.path;
      default = null;
    };

    includes = lib.mkOption {
      description = "Path/file patterns to include for perltidy";
      type = lib.types.listOf lib.types.str;
      default = [ "*.pl" ];
    };
    excludes = lib.mkOption {
      description = "Path/file patterns to exclude for perltidy";
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.perltidy = {
      command = cfg.package;

      options = lib.optional (cfg.perltidyrc != null) "-pro=${cfg.perltidyrc}" ++ cfg.options;

      inherit (cfg)
        includes
        excludes
        ;
    };
  };
}
