{ mkFormatterModule, ... }:

{
  meta.maintainers = [ "hectorgray" ];

  imports = [
    (mkFormatterModule {
      name = "air";
      package = "air-formatter";
      mainProgram = "air";
      args = [ "format" ];
      includes = [
        "*.R"
        "*.r"
      ];
    })
  ];
}
