{
  lib,
  pkgs,
  config,
  options,
  ...
}:
let
  cfg = config.programs.genemichaels;
  configFormat = pkgs.formats.json { };

  inherit (lib)
    types
    ;

  inherit (lib.lists)
    optionals
    ;

  inherit (lib.modules)
    mkIf
    ;

  inherit (lib.options)
    mkEnableOption
    mkOption
    mkPackageOption
    ;

  showOptionParent =
    opt: _n:
    assert opt._type == "option";
    lib.showOption (lib.take (lib.length opt.loc - 1) opt.loc);
in
{
  meta.maintainers = [ "djacu" ];

  options.programs.genemichaels = {
    enable = mkEnableOption "genemichaels" // {
      description = ''
        Whether to enable [`genemichaels`](https://github.com/andrewbaxter/genemichaels/blob/master/readme_genemichaels.md), a Rust code formatter.
      '';
    };
    package = mkPackageOption pkgs "genemichaels" { };

    # Configuration scheme for genemichaels, which we generate .genemichaels.json with.
    # Definition taken from https://github.com/andrewbaxter/genemichaels/blob/genemichaels-v0.5.7/readme.md#configuration
    settings = {
      max_width = mkOption {
        description = ''
          Ideal maximum line width. If there's an unbreakable element the line
          won't be split.
        '';
        type = types.ints.positive;
        example = 80;
        default = 120;
      };
      root_splits = mkOption {
        description = ''
          When breaking a child element, also break all parent elements.
        '';
        type = types.bool;
        example = true;
        default = false;
      };
      split_brace_threshold = mkOption {
        description = ''
          Break a `()` or `{}` if it has greater than this number of children.
          Set to `null` to disable breaking due to high child counts.
        '';
        type = types.nullOr types.ints.positive;
        example = null;
        default = 1;
      };
      split_attributes = mkOption {
        description = ''
          Break a `#[]` on a separate line before the element it's associated
          with.
        '';
        type = types.bool;
        example = false;
        default = true;
      };
      split_where = mkOption {
        description = ''
          Put the `where` clause on a new line.
        '';
        type = types.bool;
        example = false;
        default = true;
      };
      comment_width = mkOption {
        description = ''
          Maximum relative line length for comments (past the comment
          indentation level). Can be `null` to disable relative wrapping. If
          disabled, still wraps at `max_width`.
        '';
        type = types.nullOr types.ints.positive;
        example = null;
        default = 80;
      };
      comment_errors_fatal = mkOption {
        description = ''
          If reformatting comments results in an error, abort formatting the
          document.
        '';
        type = types.bool;
        example = true;
        default = false;
      };
      keep_max_blank_lines = mkOption {
        description = ''
          Genemichaels will replace line breaks with it's own deterministic
          line breaks. You can use this to keep extra line breaks (1 will keep
          up to 1 extra line break) during comment extraction. This is unused
          during formatting.
        '';
        type = types.ints.unsigned;
        example = 1;
        default = 0;
      };
    };

    settingsFile = mkOption {
      description = "The configuration file used by `genemichaels`.";
      type = types.path;
      example = lib.literalExpression ''./.genemichaels.json'';
      default = configFormat.generate ".genemichaels.json" cfg.settings;
      defaultText = lib.literalMD "Generated JSON file from `${showOptionParent options.programs.genemichaels.settings.max_width 1}`";
    };

    threadCount = mkOption {
      description = ''
        How many threads to use for formatting multiple files. Set to `null` to
        default to the number of cores on the system.
      '';
      type = types.nullOr types.ints.unsigned;
      example = 1;
      default = null;
    };

    includes = mkOption {
      description = ''
        Path / file patterns to include for genemichaels.
      '';
      type = types.listOf types.str;
      default = [
        "*.rs"
      ];
    };

    excludes = mkOption {
      description = ''
        Path / file patterns to exclude for genemichaels.
      '';
      type = types.listOf types.str;
      default = [ ];
    };
  };

  config = mkIf cfg.enable {
    settings.formatter.genemichaels = {
      command = "${cfg.package}/bin/genemichaels";
      options =
        (optionals (cfg.threadCount != null) [
          "--thread-count"
          (toString cfg.threadCount)
        ])
        ++ [
          "--config"
          (toString cfg.settingsFile)
        ];
      includes = cfg.includes;
      excludes = cfg.excludes;
    };
  };
}
