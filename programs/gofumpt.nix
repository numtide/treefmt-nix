{ lib, pkgs, config, ... }:
let
  cfg = config.programs.gofumpt;
in
{
  options.programs.gofumpt = {
    enable = lib.mkEnableOption "gofumpt";
    package = lib.mkPackageOption pkgs "gofumpt" { };
    extra = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = lib.mdDoc ''
        Whether to enable extra rules.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.gofumpt = {
      command = cfg.package;
      options = [ "-w" ] ++ lib.optional cfg.extra "-extra";
      includes = [ "*.go" ];
      excludes = [ "vendor/*" ];
    };
  };
}
