{ mkFormatterModule, ... }:
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "mix-format";
      package = "elixir";
      mainProgram = "mix";
      args = [ "format" ];
      includes = [
        "*.ex"
        "*.exs"
      ];
    })
  ];
}
