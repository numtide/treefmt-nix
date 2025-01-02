{ mkFormatterModule, ... }:
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "zig";
      args = [ "fmt" ];
      includes = [
        "*.zig"
        "*.zon"
      ];
    })
  ];
}
