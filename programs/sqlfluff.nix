{ lib, pkgs, config, ... }:
let
  cfg = config.programs.sqlfluff;

  # https://github.com/sqlfluff/sqlfluff/blob/main/README.md#dialects-supported
  dialects = [
    "db2"
    "ansi"
    "soql"
    "tsql"
    "hive"
    "trino"
    "mysql"
    "oracle"
    "sqlite"
    "duckdb"
    "exasol"
    "athena"
    "mariadb"
    "vertica"
    "teradata"
    "redshift"
    "sparksql"
    "bigquery"
    "postgres"
    "greenplum"
    "snowflake"
    "materializ"
    "clickhouse"
    "databricks"
  ];
in
{
  meta.maintainers = [ ];

  options.programs.sqlfluff = {
    enable = lib.mkEnableOption "sqlfluff";

    package = lib.mkPackageOption pkgs "sqlfluff" { };

    dialect = lib.mkOption {
      description = "The sql dialect to use for formatting";
      type = lib.types.enum dialects;
      default = "ansi";
      example = "sqlite";
    };

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
    settings.formatter.sqlfluff = {
      command = cfg.package;
      options = [
        "format"
        "--dialect=${cfg.dialect}"
      ];
      includes = cfg.includes;
      excludes = cfg.excludes;
    };
  };
}
