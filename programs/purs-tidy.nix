{ mkFormatterModule, ... }:
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "purs-tidy";
      package = [
        "nodePackages"
        "purs-tidy"
      ];
      args = [ "format-in-place" ];
      includes = [
        "src/**/*.purs"
        "test/**/*.purs"
      ];
    })
  ];
}
