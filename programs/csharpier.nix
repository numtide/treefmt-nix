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
        # "*.slnx" # add this with 1.0.3 release
      ];
    })
  ];
}
