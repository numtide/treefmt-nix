{ mkFormatterModule, ... }:
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "leptosfmt";
      includes = [ "*.rs" ];
    })
  ];
}
