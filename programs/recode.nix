{ mkFormatterModule, ... }:

{
  meta.maintainers = [ "haruki7049" ];

  imports = [
    (mkFormatterModule {
      name = "recode";
      mainProgram = "recode";
      args = [ "--struct" ];
      includes = [ "*" ];
    })
  ];
}
