{ mkFormatterModule, ... }:
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "taplo";
      args = [ "format" ];
      includes = [ "*.toml" ];
    })
  ];
}
