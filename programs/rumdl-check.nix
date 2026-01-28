{
  mkFormatterModule,
  ...
}:
{
  meta.maintainers = [ "delafthi" ];

  imports = [
    (mkFormatterModule {
      name = "rumdl-check";
      package = "rumdl";
      args = [
        "check"
        "--fix"
      ];
      includes = [ "*.md" ];
    })
  ];
}
