{ mkFormatterModule, ... }:
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "zig";
      package = "zig";
      args = [ "fmt" ];
      includes = [
        "*.zig"
        "*.zon"
      ];
    })
  ];
}
