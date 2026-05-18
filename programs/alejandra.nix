{
  lib,
  pkgs,
  config,
  mkFormatterModule,
  ...
}:
let
  inherit (lib) mkOption types;

  cfg = config.programs.alejandra;
  configFormat = pkgs.formats.toml { };
in
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "alejandra";
      includes = [ "*.nix" ];
    })
  ];

  options.programs.alejandra.settings = {
    indentation = mkOption {
      description = "Indentation style to use when formatting Nix files.";
      type = types.nullOr (
        types.enum [
          "TwoSpaces"
          "FourSpaces"
          "Tabs"
        ]
      );
      default = null;
      example = "FourSpaces";
    };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.alejandra.options =
      let
        settings = lib.filterAttrsRecursive (_: v: v != null) cfg.settings;
        configFile = configFormat.generate "alejandra.toml" settings;
      in
      lib.optionals (settings != { }) [
        "--experimental-config"
        (toString configFile)
      ];
  };
}
