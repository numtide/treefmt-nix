{
  lib,
  pkgs,
  config,
  mkFormatterModule,
  ...
}:
let
  inherit (lib.types)
    bool
    int
    enum
    nullOr
    ;

  cfg = config.programs.stylua;
  configFormat = pkgs.formats.toml { };

  /*
    The schema and descriptions were taken from the StyLua README
    on the project's GitHub page:
    <https://github.com/JohnnyMorganz/StyLua/blob/main/README.md>
  */
  settingsSchema = {
    column_width = lib.mkOption {
      description = ''
        Approximate line length for printing.

        Used as a guide for line wrapping -
        this is not a hard requirement:
        lines may fall under or over the limit.
      '';
      type = nullOr int;
      example = 120;
      default = null;
    };

    line_endings = lib.mkOption {
      description = ''
        Line endings type.
      '';
      type = nullOr (enum [
        "Unix"
        "Windows"
      ]);
      example = "Unix";
      default = null;
    };

    indent_type = lib.mkOption {
      description = ''
        Indent type.
      '';
      type = nullOr (enum [
        "Tabs"
        "Spaces"
      ]);
      example = "Tabs";
      default = null;
    };

    indent_width = lib.mkOption {
      description = ''
        Character size of single indentation.

        If `indent_type` is set to `Tabs`,
        this option is used as a heuristic to
        determine column width only.
      '';
      type = nullOr int;
      example = 4;
      default = null;
    };

    quote_style = lib.mkOption {
      description = ''
        Quote style for string literals.

        `AutoPrefer` styles will prefer the
        specified quote style, but fall back to
        the alternative if it has fewer string
        escapes. `Force` styles always use the
        specified style regardless of escapes.
      '';
      type = nullOr (enum [
        "AutoPreferDouble"
        "AutoPreferSingle"
        "ForceDouble"
        "ForceSingle"
      ]);
      example = "AutoPreferDouble";
      default = null;
    };

    call_parentheses = lib.mkOption {
      description = ''
        Whether parentheses should be applied on
        function calls with a single string/table
        argument.  `Always` applies parentheses in
        all cases. `NoSingleString` omits
        parentheses on calls with a single string
        argument. Similarly, `NoSingleTable` omits
        parentheses on calls with a single table
        argument. `None` omits parentheses in both
        cases.

        Note: parentheses are still kept in situations
        where removal can lead to obscurity
        (e.g. `foo "bar".setup -> foo("bar").setup`,
        since the index is on the call result, not the string).

        `Input` removes all automation and preserves
        parentheses only if they were present in input code:
        consistency is not enforced.
      '';
      type = nullOr (enum [
        "Always"
        "NoSingleString"
        "NoSingleTable"
        "None"
        "Input"
      ]);
      example = "Always";
      default = null;
    };

    collapse_simple_statement = lib.mkOption {
      description = ''
        Specify whether to collapse simple statements.
      '';
      type = nullOr (enum [
        "Never"
        "FunctionOnly"
        "ConditionalOnly"
        "Always"
      ]);
      example = "Never";
      default = null;
    };

    sort_requires.enabled = lib.mkOption {
      description = ''
        StyLua has built-in support for sorting
        require statements. We group consecutive
        require statements into a single "block",
        and then requires are sorted only within
        that block. Blocks of requires do not
        move around the file.

        We only include requires of the form
        `local NAME = require(EXPR)`, and sort
        lexicographically based on `NAME`.
        (We also sort Roblox services of the form
        `local NAME = game:GetService(EXPR)`)
      '';
      type = nullOr bool;
      example = false;
      default = null;
    };
  };

  settingsFile =
    let
      filterOutNull = lib.filterAttrsRecursive (_: v: v != null);
      filterOutEmptyAttrs = lib.filterAttrsRecursive (_: v: v != { });

      settings = filterOutEmptyAttrs (filterOutNull cfg.settings);
    in
    if settings != { } then configFormat.generate "stylua.toml" settings else null;
in
{
  meta.maintainers = [ "sebaszv" ];

  imports = [
    (mkFormatterModule {
      name = "stylua";
      includes = [ "*.lua" ];
    })
  ];

  options.programs.stylua = {
    settings = settingsSchema;
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.stylua = {
      options = lib.mkIf (settingsFile != null) [
        "--config-path"
        (toString settingsFile)
      ];
    };
  };
}
