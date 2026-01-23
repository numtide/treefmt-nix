{ mkFormatterModule, ... }:
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "tombi";
      args = [ "format" ];
      includes = [ "*.toml" ];
    })
  ];
}
