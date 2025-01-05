{
  mkFormatterModule,
  ...
}:
{
  meta.maintainers = [ "sebaszv" ];

  /*
    Package `dos2unix` has several binaries.
    Since `meta.mainProgram` isn't defined,
    we specify which to use.
  */
  imports = [
    (mkFormatterModule {
      name = "dos2unix";
      mainProgram = "dos2unix";
      args = [ "--keepdate" ];
      includes = [ "*" ];
    })
  ];
}
