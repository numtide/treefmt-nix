{ mkFormatterModule, ... }:
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "sqruff";
      args = [
        "fix"
        "--force"
      ];
      includes = [ "*.sql" ];
    })
  ];
}
