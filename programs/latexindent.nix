{
  mkFormatterModule,
  ...
}:
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "latexindent";
      package = "texliveMedium";
      mainProgram = "latexindent";
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
