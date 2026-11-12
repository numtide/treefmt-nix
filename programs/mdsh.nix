{ mkFormatterModule, ... }:
{
  meta.maintainers = [ "zimbatm" ];

  imports = [
    (mkFormatterModule {
      name = "mdsh";
      args = [ "--inputs" ];
      includes = [ "*.md" ];
    })
  ];
}
