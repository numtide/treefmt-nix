{ lib, pkgs, config, ... }:
let
  cfg = config.programs.clang-format;
in
{
  options.programs.clang-format = {
    enable = lib.mkEnableOption "clang-format";
    package = lib.mkPackageOption pkgs "clang-tools" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.clang-format = {
      command = "${cfg.package}/bin/clang-format";
      options = [ "-i" ];
      includes = [
        "*.c"
        "*.cc"
        "*.cpp"
        "*.h"
        "*.hh"
        "*.hpp"
      ];
    };
  };
}
