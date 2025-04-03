{
  pkgs,
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
      # sql-formatter doesn't support multiple file targets
      # see https://github.com/sql-formatter-org/sql-formatter/issues/552
      command = pkgs.writeShellScriptBin "sql-formatter-fix" ''
        for file in "$@"; do
          ${cfg.package}/bin/sql-formatter --fix ${
            lib.optionalString (cfg.dialect != null) "-l ${cfg.dialect}"
          } $file
        done
      '';
    };
  };
}
