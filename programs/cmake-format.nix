{ mkFormatterModule, ... }:
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "cmake-format";
      args = [ "--in-place" ];
      includes = [
        "*.cmake"
        "CMakeLists.txt"
      ];
    })
  ];
}
