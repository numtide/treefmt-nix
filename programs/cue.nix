{ mkFormatterModule, ... }:
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "cue";
      args = [ "fmt" ];
      includes = [ "*.cue" ];
    })
  ];
}
