{ mkFormatterModule, ... }:
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "clang-format";
      package = "clang-tools";
      mainProgram = "clang-format";
      args = [ "-i" ];
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
}
