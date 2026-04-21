{
  mkFormatterModule,
  ...
}:
{
  meta = {
    maintainers = [
      "drupol"
    ];
    skipExample = true;
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
