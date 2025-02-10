{
  lib,
  config,
  mkFormatterModule,
  ...
}:
let
  cfg = config.programs.sqlfluff-format;

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

  imports = [
    (lib.mkRenamedOptionModule [ "programs" "sqlfluff" ] [ "programs" "sqlfluff-format" ])
    (mkFormatterModule {
      name = "sqlfluff-format";
      package = "sqlfluff";
      args = [
        "format"
        "--disable-progress-bar"
        "--processes"
        "0"
      ];
      includes = [ "*.sql" ];
    })
  ];

  options.programs.sqlfluff-format = {
    dialect = lib.mkOption {
      description = "The sql dialect to use for formatting";
      type = with lib.types; nullOr (enum dialects);
      default = null;
      example = "sqlite";
    };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.sqlfluff-format = {
      options = lib.optionals (cfg.dialect != null) [
        "--dialect=${cfg.dialect}"
      ];
    };
  };
}
