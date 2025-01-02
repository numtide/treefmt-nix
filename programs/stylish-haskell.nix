{ mkFormatterModule, ... }:
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "stylish-haskell";
      args = [
        "-i"
        "-r"
      ];
      includes = [ "*.hs" ];
    })
  ];
}
