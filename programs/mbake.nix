{
  lib,
  pkgs,
  config,
  mkFormatterModule,
  ...
}:
let
  configFormat = pkgs.formats.toml { };
  cfg = config.programs.mbake;

  settingsSchema = {
    space_around_assignment = lib.mkOption {
      type = lib.types.nullOr lib.types.bool;
      default = null;
      description = "Whether to add spaces around assignment operators (=, :=, etc.)";
    };
    space_before_colon = lib.mkOption {
      type = lib.types.nullOr lib.types.bool;
      default = null;
      description = "Whether to add a space before colons in rules";
    };
    space_after_colon = lib.mkOption {
      type = lib.types.nullOr lib.types.bool;
      default = null;
      description = "Whether to add a space after colons in rules";
    };
    normalize_line_continuations = lib.mkOption {
      type = lib.types.nullOr lib.types.bool;
      default = null;
      description = "Whether to normalize line continuation backslashes";
    };
    max_line_length = lib.mkOption {
      type = lib.types.nullOr lib.types.ints.unsigned;
      default = null;
      description = "Maximum line length before wrapping";
    };
    auto_insert_phony_declarations = lib.mkOption {
      type = lib.types.nullOr lib.types.bool;
      default = null;
      description = "Whether to automatically insert .PHONY declarations for non-file targets";
    };
    group_phony_declarations = lib.mkOption {
      type = lib.types.nullOr lib.types.bool;
      default = null;
      description = "Whether to group all .PHONY declarations together";
    };
    phony_at_top = lib.mkOption {
      type = lib.types.nullOr lib.types.bool;
      default = null;
      description = "Whether to place .PHONY declarations at the top of the file";
    };
    remove_trailing_whitespace = lib.mkOption {
      type = lib.types.nullOr lib.types.bool;
      default = null;
      description = "Whether to remove trailing whitespace from lines";
    };
    ensure_final_newline = lib.mkOption {
      type = lib.types.nullOr lib.types.bool;
      default = null;
      description = "Whether to ensure the file ends with a newline";
    };
    normalize_empty_lines = lib.mkOption {
      type = lib.types.nullOr lib.types.bool;
      default = null;
      description = "Whether to normalize empty lines";
    };
    max_consecutive_empty_lines = lib.mkOption {
      type = lib.types.nullOr lib.types.ints.unsigned;
      default = null;
      description = "Maximum number of consecutive empty lines allowed";
    };
    fix_missing_recipe_tabs = lib.mkOption {
      type = lib.types.nullOr lib.types.bool;
      default = null;
      description = "Whether to fix recipe lines that are missing tabs";
    };
    indent_nested_conditionals = lib.mkOption {
      type = lib.types.nullOr lib.types.bool;
      default = null;
      description = "Whether to indent nested conditional blocks (ifdef, ifndef, etc.)";
    };
    tab_width = lib.mkOption {
      type = lib.types.nullOr lib.types.ints.unsigned;
      default = null;
      description = "Tab width in spaces for display purposes";
    };
  };

  settingsFile =
    let
      settings = lib.filterAttrsRecursive (_n: v: v != null) cfg.settings;
      formatterSettings = {
        formatter = settings;
      };
    in
    if settings != { } then configFormat.generate ".bake.toml" formatterSettings else null;
in
{
  meta.maintainers = [ "theobori" ];

  imports = [
    (mkFormatterModule {
      name = "mbake";
      args = [
        "format"
      ];
      includes = [
        "Makefile"
        "*/Makefile"
        "*.Makefile"
        "Makefile.*"
        "makefile"
        "*/makefile"
        "*.makefile"
        "makefile.*"
        "*.mk"
      ];
    })
  ];

  options.programs.mbake = {
    # Represents the mbake formatter settings
    # See https://github.com/EbodShojaei/bake/blob/main/.bake.toml.example#L13-L38
    settings = settingsSchema;
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.mbake = {
      options = (
        lib.optionals (settingsFile != null) [
          "--config"
          (toString settingsFile)
        ]
      );
    };
  };
}
