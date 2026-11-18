{ mkFormatterModule, ... }:
{
  meta.maintainers = [ "andrea11" ];

  imports = [
    (mkFormatterModule {
      name = "xmllint";
      package = "libxml2";
      mainProgram = "xmllint";
      args = [ "--format" ];
      printsResult = "fromArgument";
      includes = [
        "*.xml"
        "*.svg"
        "*.xhtml"
        "*.xsl"
        "*.xslt"
        "*.dtd"
        "*.xsd"
      ];
    })
  ];
}
