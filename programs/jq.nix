{
  config,
  lib,
  mkFormatterModule,
  pkgs,
  ...
}:
let
  cfg = config.programs.jq;
in
{
  meta.maintainers = [ "bmrips" ];

  imports = [
    (mkFormatterModule {
      name = "jq";
      package = "jq";
      includes = [ "*.json" ];
    })
  ];

  options.programs.jq = {
    indentWidth = lib.mkOption {
      description = "The amount of spaces to use for indentation";
      example = 4;
      default = null;
      type = with lib.types; nullOr int;
    };
    useTabs = lib.mkOption {
      description = "Whether to use tabs for indentation";
      example = true;
      default = null;
      type = with lib.types; nullOr bool;
    };
  };

  config = lib.mkIf cfg.enable {
    # jq can not format in-place by itself
    settings.formatter.jq.command = pkgs.writeShellApplication {
      name = "jq-wrapper";
      text =
        let
          jq =
            lib.getExe cfg.package
            + lib.optionalString (cfg.indentWidth != null) " --indent ${toString cfg.indentWidth}"
            + lib.optionalString (cfg.useTabs != null) " --tab";
        in
        ''
          for file in "$@"; do
            formatted=$(${jq} . "$file")
            original=$(<"$file")
            if [[ "$formatted" != "$original" ]]; then
              echo "$formatted" >"$file"
            fi
          done
        '';
    };
  };
}
