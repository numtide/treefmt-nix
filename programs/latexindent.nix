{
  mkFormatterModule,
  ...
}:
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "latexindent";
      package = [
        "texlivePackages"
        "latexindent"
      ];
      args = [ "-wd" ];
      includes = [
        "*.tex"
        "*.sty"
        "*.cls"
        "*.bib"
        "*.cmh"
      ];
    })
  ];
}
