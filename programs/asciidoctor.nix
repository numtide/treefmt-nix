{
  mkFormatterModule,
  ...
}:
{
  meta.maintainers = [ "l0b0" ];

  imports = [
    (mkFormatterModule {
      name = "asciidoctor";
      package = "asciidoctor";
      args = [ "--out-file=/dev/null" ];
      includes = [ "*.adoc" ];
    })
  ];
}
