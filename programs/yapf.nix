{ mkFormatterModule, ... }:
{
  meta.maintainers = [ "c4patino" ];

  imports = [
    (mkFormatterModule {
      name = "yapf";
      includes = [
        "*.py"
        "*.pyi"
      ];
      args = [ "--in-place" ];
    })
  ];
}
