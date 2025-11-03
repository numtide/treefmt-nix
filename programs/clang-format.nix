{
  mkFormatterModule,
  lib,
  config,
  ...
}:
let
  cfg = config.programs.clang-format;
in
{
  meta.maintainers = [ ];

  options.programs.clang-format.configFile = {
    type = lib.types.nullOr lib.types.path;
    description = "Optional config file override";
    default = null;
    example = "/my/special/clang-format-file";
  };

  imports = [
    (mkFormatterModule {
      name = "clang-format";
      package = "clang-tools";
      mainProgram = "clang-format";
      includes = [
        "*.c"
        "*.cc"
        "*.cpp"
        "*.h"
        "*.hh"
        "*.hpp"
        "*.glsl"
        "*.vert"
        ".tesc"
        ".tese"
        ".geom"
        ".frag"
        ".comp"
      ];
    })
  ];

  config = lib.mkIf cfg.enable {
    settings.formatter.clang-format = {
      options = [ "-i" ] ++ lib.optional (cfg.configFile != null) "--style=file:${cfg.configFile}";
    };
  };
}
