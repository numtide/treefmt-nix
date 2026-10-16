{ mkFormatterModule, ... }:
{
  meta.maintainers = [ "a-kenji" ];

  imports = [
    (mkFormatterModule {
      name = "desktop-file-validate";
      package = "desktop-file-utils";
      mainProgram = "desktop-file-validate";
      includes = [ "*.desktop" ];
    })
  ];
}
