{ mkFormatterModule, ... }:
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "mdformat";
      package = [
        "python3Packages"
        "mdformat"
      ];
      includes = [ "*.md" ];
    })
  ];
}
