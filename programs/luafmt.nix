{ mkFormatterModule, ... }:
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
}
