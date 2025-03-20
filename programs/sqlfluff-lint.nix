{
  lib,
  config,
  mkFormatterModule,
  ...
}:
let
  fcfg = config.programs.sqlfluff;
  cfg = config.programs.sqlfluff-lint;
in
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "sqlfluff-lint";
      package = "sqlfluff";
      args = [
        "lint"
        "--disable-progress-bar"
        "--processes"
        "0"
      ];
      includes = [ "*.sql" ];
    })
  ];

  config = lib.mkIf cfg.enable {
    settings.formatter.sqlfluff-lint = {
      options = lib.optionals (fcfg.dialect != null) [
        "--dialect=${fcfg.dialect}"
      ];
    };
  };
}
