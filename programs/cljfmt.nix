{ mkFormatterModule, ... }:
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "cljfmt";
      args = [ "fix" ];
      includes = [
        "*.clj"
        "*.cljc"
        "*.cljs"
        "*.cljx"
      ];
    })
  ];
}
