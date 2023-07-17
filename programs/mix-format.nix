{ lib, pkgs, config, ... }:
let
  cfg = config.programs.mix-format;
in
{
  options.programs.mix-format = {
    enable = lib.mkEnableOption "mix-format";
    package = lib.mkPackageOption pkgs "elixir" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.mix-format = {
      command = "${cfg.package}/bin/mix";
      options = [ "format" ];
      includes = [ "*.ex" "*.exs" ];
    };
  };
}
