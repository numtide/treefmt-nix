{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.programs.sqruff;
in
{
  meta.maintainers = [ ];

  options.programs.sqruff = {
    enable = lib.mkEnableOption "sqruff";

    package = lib.mkPackageOption pkgs "sqruff" { };

    includes = lib.mkOption {
      description = "Array of patterns (globs) to use to find files to format";
      type = lib.types.nullOr (lib.types.listOf lib.types.str);
      default = [ "*.sql" ];
    };

    excludes = lib.mkOption {
      description = "Array of patterns (globs) to exclude files or directories to format";
      type = lib.types.nullOr (lib.types.listOf lib.types.str);
      default = [ ];
    };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.sqruff = {
      command = cfg.package;
      options = [
        "fix"
        "--force"
      ];
      includes = cfg.includes;
      excludes = cfg.excludes;
    };
  };
}
