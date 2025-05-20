{ mkFormatterModule, ... }:
{
  meta.maintainers = [ "rbpatt2019" ];

  imports = [
    (mkFormatterModule {
      name = "rstfmt";
      args = [
        "-w"
        "80"
      ];
      includes = [
        "*.rst"
        "*.txt"
      ];
    })
  ];
}
