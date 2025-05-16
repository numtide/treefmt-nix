{
  lib,
  pkgs,
  config,
  mkFormatterModule,
  ...
}:
let
  cfg = config.programs.buf;
in
{
  meta.maintainers = [
    "drew-dirac"
  ];

  imports = [
    (mkFormatterModule {
      name = "buf";
      includes = [ "*.proto" ];
    })
  ];

  config = lib.mkIf cfg.enable {
    settings.formatter.buf = {
      # buf doesn't support multiple file targets
      command = pkgs.writeShellScriptBin "buf-wrapper" ''
        for file in "$@"; do
          ${lib.getExe cfg.package} format -w "$file"
        done
      '';
    };
  };
}
