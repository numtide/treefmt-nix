{ lib, pkgs, config, ... }:
let
  cfg = config.programs.google-java-format;
in
{
  meta.maintainers = [ "sebaszv" ];

  options.programs.google-java-format = {
    enable = lib.mkEnableOption "google-java-format";
    package = lib.mkPackageOption pkgs "google-java-format" { };

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

    includes = lib.mkOption {
      description = "Path/file patterns to include for google-java-format";
      type = lib.types.listOf lib.types.str;
      default = [ "*.java" ];
    };
    excludes = lib.mkOption {
      description = "Path/file patterns to exclude for google-java-format";
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.google-java-format = {
      command = cfg.package;
      options = [ "--replace" ] ++ (lib.optional cfg.aospStyle "--aosp");

      inherit (cfg)
        includes
        excludes;
    };
  };
}
