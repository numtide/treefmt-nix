{ mkFormatterModule, ... }:
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "rubocop";
      includes = [ "*.rb" ];
    })
  ];
}
