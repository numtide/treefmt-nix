{
  mkFormatterModule,
  ...
}:
{
  meta = {
    maintainers = [
      "drupol"
    ];
  };

  imports = [
    (mkFormatterModule {
      name = "json-sort";
      includes = [
        "*.json"
      ];
      args = [ "--fix" ];
    })
  ];
}
