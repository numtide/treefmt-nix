{ mkFormatterModule, ... }:
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "sqruff";
      args = [ "fix" ];
      includes = [ "*.sql" ];
    })
  ];
}
