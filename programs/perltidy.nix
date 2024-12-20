{ lib, pkgs, config, ... }:
let
  cfg = config.programs.perltidy;
in
{
  meta.maintainers = [ "haruki7049" ];

  options.programs.perltidy = {
    enable = lib.mkEnableOption "perltidy";
    package = lib.mkPackageOption pkgs.perlPackages "PerlTidy" { };

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

      inherit (cfg)
        includes
        excludes;
    };
  };
}
