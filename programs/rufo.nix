{ mkFormatterModule, ... }:
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "rufo";
      args = [ "-x" ];
      includes = [ "*.rb" ];
    })
  ];
}
