{
  mkFormatterModule,
  ...
}:
{
  meta.maintainers = [ "delafthi" ];

  imports = [
    (mkFormatterModule {
      name = "rumdl-format";
      package = "rumdl";
      args = [ "fmt" ];
      includes = [ "*.md" ];
    })
  ];
}
