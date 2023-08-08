{ lib, pkgs, config, ... }:
let
  inherit (lib)
    filterAttrsRecursive mkEnableOption mkIf mkOption mkPackageOption optionals types;

  cfg = config.programs.dprint;
  configFormat = pkgs.formats.json { };

  # Configuration schema for dprint, which we generate dprint.json with.
  # Definition taken from:
  # https://raw.githubusercontent.com/dprint/dprint/5168db9ff0a9b5d42774f95edd58681fc67c9009/website/src/assets/schemas/v0.json
  settingsSchema = {
    incremental = mkOption {
      description = "Whether to format files only when they change.";
      type = types.nullOr types.bool;
      example = true;
      default = null;
    };
    extends = mkOption {
      description = "Configurations to extend.";
      type = types.nullOr (types.oneOf [ types.str (types.listOf types.str) ]);
      example = "https://dprint.dev/path/to/config/file.v1.json";
      default = null;
    };
    lineWidth = mkOption {
      description = ''
        The width of a line the printer will try to stay under. Note that the
        printer may exceed this width in certain cases.
      '';
      type = types.nullOr types.int;
      example = 80;
      default = null;
    };
    indentWidth = mkOption {
      description = "The number of characters for an indent";
      type = types.nullOr types.int;
      example = 2;
      default = null;
    };
    useTabs = mkOption {
      description = ''
        Whether to use tabs (true) or spaces (false) for indentation.
      '';
      type = types.nullOr types.bool;
      example = true;
      default = null;
    };
    newLineKind = mkOption {
      description = ''
        The kind of newline to use (one of: auto, crlf, lf, system).
      '';
      type = types.nullOr types.str;
      example = "auto";
      default = null;
    };
    includes = mkOption {
      description = "Array of patterns (globs) to use to find files to format.";
      type = types.nullOr (types.listOf types.str);
      example = [ "**/*.{ts,tsx,js,jsx,mjs,json,md}" ];
      default = null;
    };
    excludes = mkOption {
      description = ''
        Array of patterns (globs) to exclude files or directories to format.
      '';
      type = types.nullOr (types.listOf types.str);
      example = [ "**/node_modules" "**/*-lock.json" ];
      default = null;
    };
    plugins = mkOption {
      description = "Array of plugin URLs to format files.";
      type = types.nullOr (types.listOf types.str);
      example = [
        "https://plugins.dprint.dev/json-0.17.2.wasm"
        "https://plugins.dprint.dev/markdown-0.15.2.wasm"
        "https://plugins.dprint.dev/typescript-0.84.4.wasm"
      ];
      default = null;
    };
  };

  settingsFile =
    let
      # remove all null values
      settings = filterAttrsRecursive (n: v: v != null) cfg.settings;
    in
    if settings != { } then
      configFormat.generate "dprint.json" settings
    else
      null;
in
{
  options.programs.dprint = {
    enable = mkEnableOption "dprint";
    package = mkPackageOption pkgs "dprint" { };

    # Represents the dprint.json config schema
    settings = settingsSchema;
  };

  config = mkIf cfg.enable {
    settings.formatter.dprint = {
      command = cfg.package;
      options = [ "fmt" ] ++ (optionals (settingsFile != null) [
        "--config"
        (toString settingsFile)
      ]);
      includes =
        if cfg.settings.includes != null then cfg.settings.includes else [ ".*" ];
    };
  };
}
