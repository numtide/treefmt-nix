{
  lib,
  config,
  mkFormatterModule,
  ...
}:
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

  config = lib.mkIf cfg.enable {
    settings.formatter.fish_indent = {
      command = "${cfg.package}/bin/fish_indent";
    };
  };
}
