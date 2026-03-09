{ mkFormatterModule, ... }:
{
  meta.maintainers = [ "kpbaks" ];

  imports = [
    (mkFormatterModule {
      name = "hurlfmt";
      package = "hurl";
      mainProgram = "hurlfmt";
      args = [ "--in-place" ];
      includes = [
        "*.hurl"
      ];
    })
  ];
}
