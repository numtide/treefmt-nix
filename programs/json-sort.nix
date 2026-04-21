{
  mkFormatterModule,
  ...
}:
{
  meta = {
    # Example contains store paths
    skipExample = true;
    maintainers = [ ];
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
