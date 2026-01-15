{
  config,
  mkFormatterModule,
  lib,
  ...
}:
let
  cfg = config.programs.clang-tidy;
in
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "clang-tidy";
      package = "clang-tools";
      mainProgram = "clang-tidy";
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

  options.programs.clang-tidy = {
    configFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      description = "Specify the path of .clang-tidy or custom config file";
      default = null;
      example = "/some/path/myTidyConfigFile";
    };
    compileCommandsPath = lib.mkOption {
      type = with lib.types; nullOr (either path str);
      description = "used to read a compile command database";
      default = null;
      example = "/my/cmake/build/directory";
    };
    quiet = lib.mkOption {
      type = lib.types.bool;
      description = "Run clang-tidy in quiet mode";
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.clang-tidy = {
      options = [
        "--fix"
      ]
      ++ lib.optional (cfg.configFile != null) "--config-file=${cfg.configFile}"
      ++ lib.optional (cfg.compileCommandsPath != null) "-p=${cfg.compileCommandsPath}"
      ++ lib.optional cfg.quiet "--quiet";
    };
  };
}
