{
  lib,
  config,
  mkFormatterModule,
  ...
}:
let
  cfg = config.programs.wgslfmt;
in
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "wgslfmt";
      package = "wgsl-analyzer";
      mainProgram = "wgslfmt";
      includes = [ "*.wgsl" ];
    })
  ];

  options.programs.wgslfmt = {
    tabs = lib.mkEnableOption "Use tabs for indentation (instead of spaces)";
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.wgslfmt.options = lib.optional cfg.tabs "--tabs";
  };
}
