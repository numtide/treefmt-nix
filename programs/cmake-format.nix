{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.programs.cmake-format;
in
{
  meta.maintainers = [ ];

  options.programs.cmake-format = {
    enable = lib.mkEnableOption "cmake-format";
    package = lib.mkPackageOption pkgs "cmake-format" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.cmake-format = {
      command = "${cfg.package}/bin/cmake-format";
      options = [ "--in-place" ];
      includes = [
        "*.cmake"
        "CMakeLists.txt"
      ];
    };
  };
}
