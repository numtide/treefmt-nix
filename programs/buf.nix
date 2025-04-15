{ mkFormatterModule, ... }:
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "buf";
      args = [
        "format"
        "-w"
      ];
      includes = [
        "*.proto"
      ];
    })
  ];
}
