{
  config,
  lib,
  mkFormatterModule,
  ...
}:
let
  cfg = config.programs.shellcheck;
in
{
  meta.maintainers = [ "zimbatm" ];
  meta.brokenPlatforms = [ "riscv64-linux" ];

  options.programs.shellcheck = {
    external-sources = lib.mkEnableOption "Allow sources outside of `includes`";
    extra-checks = lib.mkOption {
      description = ''
        List of optional checks to enable (or "all")
      '';
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "all" ];
    };
    severity = lib.mkOption {
      description = ''
        Minimum severity of errors to consider ("error", "warning", "info", "style")
      '';
      type = lib.types.nullOr lib.types.str;
      default = null;
    };
    source-path = lib.mkOption {
      description = ''
        Specify path when looking for sourced files ("SCRIPTDIR" for script's dir)
      '';
      type = lib.types.nullOr lib.types.str;
      default = null;
    };
  };

  imports = [
    (mkFormatterModule {
      name = "shellcheck";
      includes = [
        "*.sh"
        "*.bash"
        # direnv
        "*.envrc"
        "*.envrc.*"
      ];
    })
  ];

  config = lib.mkIf cfg.enable {
    settings.formatter.shellcheck.options =
      (lib.optional cfg.external-sources "--external-sources")
      ++ (lib.optional (
        cfg.extra-checks != [ ]
      ) "--enable=${lib.strings.concatStringsSep "," cfg.extra-checks}")
      ++ (lib.optional (cfg.severity != null) "--severity=${cfg.severity}")
      ++ (lib.optional (cfg.source-path != null) "--source-path=${cfg.source-path}");
  };
}
