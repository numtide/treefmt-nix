{
  config,
  lib,
  mkFormatterModule,
  pkgs,
  ...
}:
let
  cfg = config.programs.xmllint;
in
{
  meta.maintainers = [ "andrea11" ];

  imports = [
    (mkFormatterModule {
      name = "xmllint";
      package = "libxml2";
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

  config = lib.mkIf cfg.enable {
    settings.formatter.xmllint = {
      # xmllint doesn't format in place by default
      command = pkgs.writeShellApplication {
        name = "xmllint-wrapper";
        text = ''
          for file in "$@"; do
            ${lib.getExe' cfg.package "xmllint"} --format "$file" --output "$file"
          done
        '';
      };
    };
  };
}
