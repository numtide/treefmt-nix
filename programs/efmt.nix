{
  config,
  mkFormatterModule,
  ...
}:

{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "efmt";
      args = [ "--write" ];
      includes = [
        "*.erl"
        "*.hrl"
        "*.app"
        "*.app.src"
        "*.config"
        "*.script"
        "*.escript"
      ];
    })
  ];
}
