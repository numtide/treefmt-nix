{
  lib,
  config,
  mkFormatterModule,
  ...
}:
let
  cfg = config.programs.google-java-format;
in
{
  meta.maintainers = [ "sebaszv" ];

  imports = [
    (mkFormatterModule {
      name = "google-java-format";
      args = [ "--replace" ];
      includes = [ "*.java" ];
    })
  ];

  options.programs.google-java-format = {
    aospStyle = lib.mkOption {
      description = ''
        Whether to use AOSP (Android Open Source Project) indentation.
        In a few words, use 4-space indentation rather than the conventional
        2-space indentation width that Google uses.
      '';
      type = lib.types.bool;
      example = true;
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.google-java-format.options = lib.optional cfg.aospStyle "--aosp";
  };
}
