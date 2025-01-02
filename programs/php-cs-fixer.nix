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
        "phpPackages"
        "php-cs-fixer"
      ];
      args = [ "fix" ];
      includes = [ "*.php" ];
    })
  ];

  options.programs.php-cs-fixer = {
    configFile = lib.mkOption {
      description = "Path to php-cs-fixer config file.";
      type = types.oneOf [
        types.str
        types.path
      ];
      default = "./.php-cs-fixer.php";
      example = "./.php-cs-fixer.dist.php";
    };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.php-cs-fixer = {
      options = [
        "--config"
        "${cfg.configFile}"
      ];
    };
  };
}
