{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.programs.zig;
in
{
  meta.maintainers = [ ];

  options.programs.zig = {
    enable = lib.mkEnableOption "zig";
    package = lib.mkPackageOption pkgs "zig" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.zig = {
      command = cfg.package;
      options = [ "fmt" ];
      includes = [
        "*.zig"
        "*.zon"
      ];
    };
  };
}
