{
  lib,
  config,
  mkFormatterModule,
  ...
}:
let
  inherit (lib) types;
  cfg = config.programs.php-cs-fixer;
in
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "php-cs-fixer";
      package = [
        "php83Packages"
        "php-cs-fixer"
      ];
      args = [ "fix" ];
      includes = [ "*.php" ];
    })
  ];

  options.programs.php-cs-fixer = {
    configFile = lib.mkOption {
      description = "Path to php-cs-fixer config file.";
      type = types.nullOr (types.pathWith { });
      default = null;
      example = lib.literalExpression "./.php-cs-fixer.dist.php";
    };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.php-cs-fixer = {
      options = lib.optionals (cfg.configFile != null) [
        "--config"
        "${cfg.configFile}"
      ];
    };
  };
}
