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
      args = [ "--logfile=/dev/null" ];
      printsResult = "fromArgument";
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
