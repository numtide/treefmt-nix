{
  config,
  lib,
  mkFormatterModule,
  pkgs,
  ...
}:
let
  cfg = config.programs.luafmt;
  configFormat = pkgs.formats.toml { };

  settingsSchema = lib.mkOption {
    default = { };
    example = {
      layout = {
        max_line_width = 100;
        table_expand = "Auto";
        call_args_expand = "Auto";
        func_params_expand = "Auto";
      };
      output = {
        quote_style = "Preserve";
        trailing_table_separator = "Multiline";
        single_arg_call_parens = "Preserve";
      };
      comments = {
        align_in_statements = false;
        align_in_table_fields = true;
        align_in_call_args = true;
        align_in_params = true;
      };
      align = {
        continuous_assign_statement = false;
        table_field = true;
      };
    };
    description = ''
      Configuration to generate {file}`luafmt.toml` with.

      See Formatter Options on the project's GitHub page for configuration groups,
      defaults, and what each option changes:

      <https://github.com/EmmyLuaLs/emmylua-analyzer-rust/blob/main/docs/emmylua_formatter/options_EN.md>
    '';
    type = lib.types.submodule { freeformType = configFormat.type; };
  };

  settingsFile =
    if cfg.settings != { } then configFormat.generate "luafmt.toml" cfg.settings else null;
in
{
  meta.maintainers = [ "juangiordana" ];

  imports = [
    (mkFormatterModule {
      name = "luafmt";
      package = "emmylua-formatter";
      args = [ "--write" ];
      stdinArgs = [ "--stdin" ];
      includes = [ "*.lua" ];
    })
  ];

  options.programs.luafmt = {
    settings = settingsSchema;
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.luafmt = {
      options = lib.mkIf (settingsFile != null) [
        "--config"
        (toString settingsFile)
      ];
    };
  };
}
