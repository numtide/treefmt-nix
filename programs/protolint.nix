{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.programs.protolint;
in
{
  meta.maintainers = [ ];

  options.programs.protolint = {
    enable = lib.mkEnableOption "protolint";
    package = lib.mkPackageOption pkgs "protolint" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.protolint = {
      command = cfg.package;
      options = [
        "lint"
        "-fix"
      ];
      includes = [ "*.proto" ];
    };
  };
}
