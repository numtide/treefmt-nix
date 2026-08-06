{ mkFormatterModule, ... }:
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "swift-format";
      args = [ "-i" ];
      includes = [ "*.swift" ];
    })
  ];
}
