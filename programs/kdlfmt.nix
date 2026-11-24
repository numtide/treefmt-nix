{
  lib,
  pkgs,
  config,
  mkFormatterModule,
  ...
}:
let
  cfg = config.programs.kdlfmt;
in
{
  meta.maintainers = [ "tetov" ];

  imports = [
    (mkFormatterModule {
      name = "kdlfmt";
      args = [ cfg.formatCommand ];
      includes = [
        "*.kdl"
      ];
    })
  ];

  options.programs.kdlfmt = {
    formatCommand = lib.mkOption {
      type = lib.types.enum [
        "format"
        "check"
      ];
      description = "The command to run kdlfmt with.";
      default = "format";
      example = "check";
    };
    kdlVersion = lib.mkOption {
      type = lib.types.enum [
        "v1"
        "v2"
        null
      ];
      default = null;
      description = "kdl specification to use. By default all versions are tried";
    };
    settings = lib.mkOption {
      type =
        with lib.types;
        attrsOf (oneOf [
          bool
          int
          str
        ]);
      description = "kdlfmt configuration.";
      default = { };
      example = {
        indent_size = 4;
        use_tabs = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.kdlfmt.options =
      let
        inherit (lib)
          concatMapAttrsStringSep
          isAttrs
          isBool
          toString
          ;
        toSimpleKDL =
          v:
          if isAttrs v then
            concatMapAttrsStringSep "\n" (key: value: "${key} ${toSimpleKDL value}") v
          else if isBool v then
            (if v then "#true" else "#false")
          else
            toString v;
        kdlFile = pkgs.writeText "kdlfmt.kdl" (toSimpleKDL cfg.settings);
      in
      lib.optionals (cfg.settings != { }) [
        "--config"
        "${kdlFile}"
      ]
      ++ lib.optionals (cfg.kdlVersion != null) [
        "--kdl-version"
        cfg.kdlVersion
      ];
  };
}
