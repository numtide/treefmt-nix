{ lib, pkgs, config, ... }:
let
  inherit (lib) types;
  cfg = config.programs.php-cs-fixer;
in
{
  options.programs.php-cs-fixer = {
    enable = lib.mkEnableOption "php-cs-fixer";
    package = lib.mkPackageOption pkgs.phpPackages "php-cs-fixer" { };
    configFile = lib.mkOption {
      description = "Path to php-cs-fixer config file.";
      type = types.oneOf [ types.str types.path ];
      default = "./.php-cs-fixer.php";
      example = "./.php-cs-fixer.dist.php";
    };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.php-cs-fixer = {
      command = "${cfg.package}/bin/php-cs-fixer";
      options = [ "fix" "--config" "${cfg.configFile}" ];
      includes = [ "*.php" ];
    };
  };
}
