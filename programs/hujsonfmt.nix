{ mkFormatterModule, ... }:
{
  meta.maintainers = [ "fjij" ];

  imports = [
    (mkFormatterModule {
      name = "hujsonfmt";
      printsResult = "fromArgument";
      includes = [ "*.hujson" ];
    })
  ];
}
