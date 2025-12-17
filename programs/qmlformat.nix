{
  pkgs,
  mkFormatterModule,
  ...
}:
{
  meta = {
    maintainers = [ "rotmh" ];
    platforms = pkgs.lib.platforms.linux;
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
