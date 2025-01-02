{ mkFormatterModule, ... }:
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "gdformat";
      package = "gdtoolkit_4";
      mainProgram = "gdformat";
      includes = [ "*.gd" ];
    })
  ];
}
