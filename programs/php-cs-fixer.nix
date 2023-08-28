{ lib, pkgs, config, ... }:
let
  cfg = config.programs.php-cs-fixer;
in
{
  options.programs.php-cs-fixer = {
    enable = lib.mkEnableOption "php-cs-fixer";
    package = lib.mkPackageOption pkgs.phpPackages "php-cs-fixer" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.php-cs-fixer = {
      command = "${cfg.package}/bin/php-cs-fixer";
      options = [ "fix" ];
      includes = [ "*.php" ];
    };
  };
}
