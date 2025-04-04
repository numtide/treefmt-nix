{
  lib,
  config,
  mkFormatterModule,
  ...
}:
let
  cfg = config.programs.oxipng;
in
{
  meta.maintainers = [ "nim65s" ];

  imports = [
    (mkFormatterModule {
      name = "oxipng";
      includes = [ "*.png" ];
    })
  ];

  options.programs.oxipng = {
    alpha = lib.mkEnableOption "Perform additional optimization on images with an alpha channel";
    opt = lib.mkOption {
      description = "Set the optimization level preset";
      type = with lib.types; str;
      example = "max";
      default = "2";
    };
    scale16 = lib.mkEnableOption "Forcibly reduce images with 16 bits per channel to 8 bits per channel";
    strip = lib.mkOption {
      description = "Strip metadata chunks";
      type = with lib.types; nullOr str;
      example = "safe";
      default = null;
    };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.oxipng = {
      options =
        [
          "--opt"
          cfg.opt
        ]
        ++ lib.optionals cfg.alpha [
          "--alpha"
        ]
        ++ lib.optionals cfg.scale16 [
          "--scale16"
        ]
        ++ lib.optionals (cfg.strip != null) [
          "--strip"
          cfg.strip
        ];
    };
  };
}
