{
  mkFormatterModule,
  ...
}:
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "dos2unix";
      args = [ "--keepdate" ];
      includes = [ "*" ];
    })
  ];
}
