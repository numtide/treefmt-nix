{
  mkFormatterModule,
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.programs.prolog-lsp-server;

  lsp-server = pkgs.fetchzip {
    name = "lsp_server";
    url = "https://github.com/jamesnvc/lsp_server/archive/v3.14.0.zip";
    sha256 = "sha256-TKJxGcz170nit1kdUXQKZi5C5jq+MsW3w5FSqTfxqow=";
  };

  swiplWithFormatter = cfg.package.override {
    extraPacks = map (dep-path: "'file://${dep-path}'") [
      lsp-server
    ];
  };
in
{
  meta.maintainers = [ lib.maintainers.baileylu ];

  imports = [
    (mkFormatterModule {
      name = "prolog-lsp-server";
      package = "swi-prolog";
      includes = [
        "*.pl"
        "*.pro"
      ];
    })
  ];

  config = lib.mkIf cfg.enable {
    settings.formatter.prolog-lsp-server = {
      # lsp_server doesn't support multiple file targets
      command = pkgs.writeShellApplication {
        name = "prolog-lsp-server";
        text = ''
          for file in "$@"; do
            ${lib.getExe swiplWithFormatter} formatter "$file"
          done
        '';
      };
    };
  };
}
