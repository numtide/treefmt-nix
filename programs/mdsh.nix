{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.programs.mdsh;
in
{
  meta.maintainers = [ "zimbatm" ];

  options.programs.mdsh = {
    enable = lib.mkEnableOption "mdsh";
    package = lib.mkPackageOption pkgs "mdsh" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.mdsh = {
      command = cfg.package;
      options = [ "--inputs" ];
      includes = [ "README.md" ];
    };
  };
}
