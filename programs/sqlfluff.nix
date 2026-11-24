{
  lib,
  config,
  mkFormatterModule,
  ...
}:
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

  imports = [
    (mkFormatterModule {
      name = "sqlfluff";
      args = [
        "format"
        "--disable-progress-bar"
        "--processes"
        "0"
      ]
      ++ lib.optionals (cfg.configFile != null) [
        "--config"
        "${cfg.configFile}"
      ];
      includes = [ "*.sql" ];
    })
  ];

  options.programs.sqlfluff = {
    dialect = lib.mkOption {
      description = "The sql dialect to use for formatting";
      type = with lib.types; nullOr (enum dialects);
      default = null;
      example = "sqlite";
    };

    configFile = lib.mkOption {
      description = "The config file to pass when formatting";
      type = lib.types.path;
      default = null;
    };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.sqlfluff = {
      options = lib.optionals (cfg.dialect != null) [
        "--dialect=${cfg.dialect}"
      ];
    };
  };
}
