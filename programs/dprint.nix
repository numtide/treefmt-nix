{ lib, pkgs, config, ... }:
let
  inherit (lib)
    filterAttrsRecursive literalMD mkEnableOption mkIf mkOption mkPackageOption types;

  cfg = config.programs.dprint;
  configFormat = pkgs.formats.json { };

  # Configuration schema for dprint, which we generate dprint.json with.
  # Definition taken from:
  # https://raw.githubusercontent.com/dprint/dprint/5168db9ff0a9b5d42774f95edd58681fc67c9009/website/src/assets/schemas/v0.json
  configSchema = {
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
      description = "The width of a line the printer will try to stay under. Note that the printer may exceed this width in certain cases.";
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
      description = "Whether to use tabs (true) or spaces (false) for indentation.";
      type = types.nullOr types.bool;
      example = true;
      default = null;
    };
    newLineKind = mkOption {
      description = "The kind of newline to use (one of: auto, crlf, lf, system).";
      type = types.nullOr types.str;
      example = "auto";
      default = null;
    };
    includes = mkOption {
      description = "Array of patterns (globs) to use to find files to format.";
      type = types.nullOr (types.listOf types.str);
      example = [ "**/*.{ts,tsx,js,jsx,mjs,json,md}" ];
      default = [ ".*" ];
    };
    excludes = mkOption {
      description = "Array of patterns (globs) to exclude files or directories to format.";
      type = types.nullOr (types.listOf types.string);
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

  # We filter out null values in dprint configuration since dprint errors when
  # they're present
  mkConfigFile = { filename ? "dprint.json", config ? { } }:
    configFormat.generate filename (filterAttrsRecursive (n: v: v != null) config);
in
{
  options.programs.dprint = {
    enable = mkEnableOption "dprint";
    package = mkPackageOption pkgs "dprint" { };

    # Represents the dprint.json config schema
    config = configSchema;

    # Wrapped dprint invocation passing a generated dprint.json configuration
    wrapper = mkOption {
      description = "The dprint package, wrapped with the config file.";
      type = types.package;
      defaultText = literalMD "wrapped `dprint` command";
      default =
        let
          configFile = mkConfigFile { config = cfg.config; };
          x = pkgs.writeShellScriptBin "dprint" ''
            set -euo pipefail
            exec ${lib.getExe cfg.package} --config=${configFile} "$@"
          '';
        in
        (x // { meta = config.package.meta // x.meta; });
    };
  };

  config = mkIf cfg.enable {
    settings.formatter.dprint = {
      command = cfg.wrapper;
      options = [ "fmt" ];
      includes = cfg.config.includes;
    };
  };
}
