{
  config,
  lib,
  mkFormatterModule,
  pkgs,
  ...
}:
let
  cfg = config.programs.logql;
in
{
  meta.maintainers = [ "kpbaks" ];

  imports = [
    (mkFormatterModule {
      name = "logql";
      package = "grafana-loki";
      includes = [
        "*.logql"
      ];
    })
  ];

  config = lib.mkIf cfg.enable {
    settings.formatter.logql = {
      command = pkgs.writeShellApplication {
        name = "logcli-wrapper";
        text = ''
          temp=$(mktemp)
          trap 'rm "$temp"' EXIT
          for file in "$@"; do
            ${lib.getExe' cfg.package "logcli"} fmt <"$file" > "$temp"
            if ! cmp -s "$file" "$temp"; then
              cp "$temp" "$file"
            fi
          done
        '';
      };
    };
  };
}
