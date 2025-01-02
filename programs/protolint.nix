{ mkFormatterModule, ... }:
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "protolint";
      args = [
        "lint"
        "-fix"
      ];
      includes = [ "*.proto" ];
    })
  ];
}
