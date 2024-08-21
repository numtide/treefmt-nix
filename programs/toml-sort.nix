{ lib, pkgs, config, ... }:
let
  cfg = config.programs.toml-sort;
in
{
  options.programs.toml-sort = {
    enable = lib.mkEnableOption "toml-sort";
    package = lib.mkPackageOption pkgs "toml-sort" { };
    all = lib.mkEnableOption "sort ALL keys";
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.toml-sort = {
      command = "${cfg.package}/bin/toml-sort";
      options = [ "-i" ] ++ lib.optional cfg.all "--all";
      includes = [ "*.toml" ];
    };
  };
}
