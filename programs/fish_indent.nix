let
  cfg = config.programs.fish_indent;
in
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "fish_indent";
      package = "fish";
      args = [ "--write" ];
      includes = [ "*.fish" ];
    })
  ];

  config = lib.mkIf (cfg.enable or false) {  # Защита от случая, если `cfg.enable` не определено
    settings.formatter.fish_indent = {
      command = "${cfg.package}/bin/fish_indent";
    };
  };
}
