{ mkFormatterModule, ... }:
{
  meta.maintainers = [
    "thomaslaich"
  ];

  imports = [
    (mkFormatterModule {
      name = "csharpier";
      package = "csharpier";
      mainProgram = "csharpier";
      args = [ "format" ];
      includes = [
        "*.cs"
        "*.csproj"
        "*.slnx" # support added in 1.1.0
        "*.xaml" # support added in 1.1.0
      ];
    })
  ];
}
