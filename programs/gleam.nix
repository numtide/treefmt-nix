{ mkFormatterModule, ... }:
{
  meta.maintainers = [ "anntnzrb" ];

  imports = [
    (mkFormatterModule {
      name = "gleam";
      args = [ "format" ];
      includes = [ "*.gleam" ];
    })
  ];
}
