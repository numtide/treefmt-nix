{
  lib,
  config,
  mkFormatterModule,
  ...
}:
let
  cfg = config.programs.sql-formatter;

  dialects = [
    "bigquery"
    "db2"
    "db2i"
    "hive"
    "mariadb"
    "mysql"
    "n1ql"
    "plsql"
    "postgresql"
    "redshift"
    "spark"
    "sqlite"
    "sql"
    "tidb"
    "trino"
    "transactsql"
    "tsql"
    "singlestoredb"
    "snowflake"
  ];
in
{
  imports = [
    (mkFormatterModule {
      name = "sql-formatter";
      package = "sql-formatter";
      args = [
        "--fix"
      ];
      includes = [ "*.sql" ];
    })
  ];

  options.programs.sql-formatter = {
    dialect = lib.mkOption {
      description = "The sql dialect to use for formatting";
      type = with lib.types; nullOr (enum dialects);
      default = null;
      example = "postgresql";
    };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.sql-formatter = {
      command = "${cfg.package}/bin/sql-formatter";
      options = lib.optionals (cfg.dialect != null) [
        "-l=${cfg.dialect}"
      ];
    };
  };
}
