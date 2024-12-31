{ mkFormatterModule, ... }:
{
  meta.maintainers = [ "JakobLichterfeld" ];

  imports = [
    (mkFormatterModule {
      name = "dart-format";
      package = "dart";
      args = [ "format" ];
      includes = [ "*.dart" ];
    })
  ];
}
