{
  mkFormatterModule,
  ...
}:
{
  meta.maintainers = [ "jolars" ];

  imports = [
    (mkFormatterModule {
      name = "panache-format";
      package = "panache";
      args = [ "format" ];
      includes = [
        "*.md"
        "*.markdown"
        "*.qmd"
        "*.Rmd"
      ];
    })
  ];
}
