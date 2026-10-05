{
  lib,
  pkgs,
  config,
  mkFormatterModule,
  ...
}:
let
  inherit (lib) types;
  settingsFormat = pkgs.formats.json { };
  # Current impl takes all keys regardless of value, so forbid `false` to avoid confusion
  setType = types.lazyAttrsOf (types.enum [ true ]);
  sortKeyType =
    types.either
      (types.enum [
        # The value of a string literal.
        "string"
        # A simple or dotted function name.
        "call_name"
      ])
      (
        types.attrTag {
          tuple_item = lib.mkOption {
            type = types.ints.unsigned;
            description = "The string literal at tuple index `N`.";
          };
          call_keyword = lib.mkOption {
            type = types.str;
            description = "The string literal passed to the named call argument.";
          };
          first_of = lib.mkOption {
            type = types.listOf sortKeyType;
            description = "The first enclosed sort key that applies to the element.";
          };
        }
      );

  cfg = config.programs.starlark_fmt;
in
{
  meta.maintainers = [ "lunagl" ];
  # example contains store paths
  meta.skipExample = true;

  imports = [
    (mkFormatterModule {
      name = "starlark_fmt";
      package = "buck2";
      mainProgram = "starlark_fmt";
      # order between mkBefore (500) and default (1000)
      args = lib.mkOrder 750 [ "fmt" ];
      stdinArgs = lib.mkOrder 750 [
        "stdin"
        "--path"
        "$path"
      ];
      includes = [
        "*.star"
        "*.bzl"
        # Buck2
        "BUCK"
        "PACKAGE"
        "*.bxl"
        # Bazel
        "*.bazel"
        "BUILD"
        "WORKSPACE"
        "WORKSPACE.bzlmod"
      ];
    })
  ];

  options.programs.starlark_fmt = {
    settings = lib.mkOption {
      type = types.submodule {
        freeformType = settingsFormat.type;

        options = {
          IsSortableListArg = lib.mkOption {
            type = setType;
            default = { };
            example = {
              deps = true;
              srcs = true;
              visibility = true;
            };
            description = "Set of arg names whose list values should be sorted in rule calls.";
          };
          SortableBlacklist = lib.mkOption {
            type = setType;
            default = { };
            example = {
              "genrule.srcs" = true;
            };
            description = "Set of `<callee>.<argument>` selectors to exclude from list sorting.";
          };
          NamePriority = lib.mkOption {
            type = types.lazyAttrsOf types.int;
            default = { };
            example = {
              name = -99;
              visibility = 50;
            };
            description = ''
              Priority ordering for kwargs.
              Lower numbers sort first.
              Args not listed default to priority 0 and sort alphabetically among themselves.
            '';
          };
          ListSortKeys = lib.mkOption {
            type = types.lazyAttrsOf sortKeyType;
            default = { };
            example = {
              plugins.first_of = [
                { call_keyword = "name"; }
                "call_name"
              ];
            };
            description = "Optional argument or `<callee>.<argument>` selectors mapped to structural sort keys.";
          };
        };
      };
      default = { };
      description = ''
        JSON settings passed with `--config`.

        The properties and their documentation are taken directly from [the README][1].

        [1]: https://github.com/facebook/buck2/blob/main/tools/starlark_fmt/README.md#configuration
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.starlark_fmt =
      let
        configArgs = lib.mkBefore [
          "--config"
          "${settingsFormat.generate "starlark_fmt-config.json" cfg.settings}"
        ];
      in
      {
        options = configArgs;
        stdin-options = configArgs;
      };
  };
}
