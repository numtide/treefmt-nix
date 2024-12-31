{
  mkFormatterModule,
  ...
}:
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "fnlfmt";
      args = [ "--fix" ];
      includes = [ "*.fnl" ];
    })
  ];
}
