{
  config,
  lib,
  mkFormatterModule,
  pkgs,
  ...
}:
let
  cfg = config.programs.fracjson;
in
{
  meta.maintainers = [ "allsimon" ];

  imports = [
    (mkFormatterModule {
      name = "fracjson";
      includes = [ "*.json" ];
    })
  ];

  config = lib.mkIf cfg.enable {
    settings.formatter.fracjson = {
      command = pkgs.writeShellApplication {
        name = "fracjson-wrapper";
        runtimeInputs = [ pkgs.diffutils ];
        text = ''
          temp=$(mktemp)
          trap 'rm "$temp"' EXIT
          for file in "$@"; do
            ${lib.getExe' cfg.package "fracjson"} "$file" --output-file "$temp"
            if ! cmp -s "$file" "$temp"; then
              cp "$temp" "$file"
            fi
          done
        '';
      };
    };
  };
}
