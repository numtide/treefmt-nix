{ lib, pkgs, config, ... }:
let
  cfg = config.programs.purs-tidy;
in
{
  options.programs.purs-tidy = {
    enable = lib.mkEnableOption "purs-tidy";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.nodePackages.purs-tidy;
      defaultText = lib.literalExpression "pkgs.nodePackages.purs-tidy";
      description = lib.mdDoc ''
        purs-tidy derivation to use.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.purs-tidy = {
      command = cfg.package;
      options = [ "format-in-place" ];
      includes = [
        "src/**/*.purs"
        "test/**/*.purs"
      ];
    };
  };
}
