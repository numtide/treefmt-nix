{ mkFormatterModule, ... }:
{
  meta.maintainers = [ ];
  # See https://github.com/numtide/treefmt-nix/pull/201
  meta.broken = true;

  imports = [
    (mkFormatterModule {
      name = "swift-format";
      args = [ "-i" ];
      includes = [ "*.swift" ];
    })
  ];
}
