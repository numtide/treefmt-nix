{
  pkgs,
  mkFormatterModule,
  ...
}:
{
  meta = {
    maintainers = [ "rotmh" ];
    platforms = pkgs.lib.platforms.linux;
    skipExample = true;
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
