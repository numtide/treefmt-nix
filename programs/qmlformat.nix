{
  mkFormatterModule,
  ...
}:
{
  meta.maintainers = [
    "fvrings"
  ];

  imports = [
    (mkFormatterModule {
      name = "qmlformat";
      mainProgram = "qmlformat";
      package = [
        "kdePackages"
        "qtdeclarative"
      ];
      args = [
        "-i"
      ];
      includes = [
        "*.qml"
      ];
    })
  ];

}
