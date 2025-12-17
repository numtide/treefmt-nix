{
  pkgs,
  mkFormatterModule,
  ...
}:
{
  meta = {
    maintainers = [ "rotmh" ];
    platforms = pkgs.kdePackages.qtdeclarative.meta.platforms;
  };

  imports = [
    (mkFormatterModule {
      name = "qmlformat";
      mainProgram = "qmlformat";
      package = [
        "kdePackages"
        "qtdeclarative"
      ];
      args = [ "-i" ];
      includes = [ "*.qml" ];
    })
  ];
}
