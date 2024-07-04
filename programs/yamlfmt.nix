{ lib, pkgs, config, ... }:
let
  cfg = config.programs.yamlfmt;
in
{
  options.programs.yamlfmt = {
    enable = lib.mkEnableOption "yamlfmt";
    package = lib.mkPackageOption pkgs "yamlfmt" { };
    indent = lib.mkOption {
      type = lib.types.nullOr lib.types.int;
      default = null;
      description = "The indentation level in spaces to use for the formatted yaml.";
    };
    include_document_start = lib.mkOption {
      type = lib.types.nullOr lib.types.bool;
      default = null;
      description = "Include --- at document start.";
    };
    retain_line_breaks = lib.mkOption {
      type = lib.types.nullOr lib.types.bool;
      default = null;
      description = "Retain line breaks in formatted yaml.";
    };
    retain_line_breaks_single = lib.mkOption {
      type = lib.types.nullOr lib.types.bool;
      default = null;
      description = ''
        Retain line breaks in formatted yaml, but only keep a single line in groups of many blank lines.
        (NOTE: Takes precedence over retain_line_breaks)
      '';
    };
    disallow_anchors = lib.mkOption {
      type = lib.types.nullOr lib.types.bool;
      default = null;
      description = "If true, reject any YAML anchors or aliases found in the document.";
    };
    max_line_length = lib.mkOption {
      type = lib.types.nullOr lib.types.int;
      default = null;
      description = "Set the maximum line length. if not set, defaults to 0 which means no limit.";
    };
    scan_folded_as_literal = lib.mkOption {
      type = lib.types.nullOr lib.types.bool;
      default = null;
      description = "Option that will preserve newlines in folded block scalars (blocks that start with `>`).";
    };
    indentless_arrays = lib.mkOption {
      type = lib.types.nullOr lib.types.bool;
      default = null;
      description = "Render `-` array items (block sequence items) without an increased indent.";
    };
    drop_merge_tags = lib.mkOption {
      type = lib.types.nullOr lib.types.bool;
      default = null;
      description = "Assume that any well formed merge using just a `<<` token will be a merge, and drop the `!!merge` tag from the formatted result.";
    };
    pad_line_comments = lib.mkOption {
      type = lib.types.nullOr lib.types.int;
      default = null;
      description = "The number of padding spaces to insert before line comments.";
    };
    trim_trailing_whitespace = lib.mkOption {
      type = lib.types.nullOr lib.types.bool;
      default = null;
      description = "Trim trailing whitespace from lines.";
    };
    eof_newline = lib.mkOption {
      type = lib.types.nullOr lib.types.bool;
      default = null;
      description = "Always add a newline at end of file. Useful in the scenario where retain_line_breaks is disabled but the trailing newline is still needed.";
    };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.yamlfmt = {
      command = cfg.package;
      options =
        let
          formatterOpts = {
            inherit (cfg)
              indent
              include_document_start
              retain_line_breaks
              retain_line_breaks_single
              disallow_anchors
              max_line_length
              scan_folded_as_literal
              indentless_arrays
              drop_merge_tags
              pad_line_comments
              trim_trailing_whitespace
              eof_newline;
          };
          stringify = v: if lib.isBool v then lib.boolToString v else toString v;
        in
        lib.mapAttrsToList
          (n: v: "-formatter=${n}=${stringify v}")
          (lib.filterAttrs (n: v: v != null) formatterOpts);
      includes = [ "*.yaml" "*.yml" ];
    };
  };
}
