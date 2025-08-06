{ mkFormatterModule, ... }:
{
  meta.maintainers = [ "zimbatm" ];
  meta.brokenPlatforms = [ "riscv64-linux" ];

  imports = [
    (mkFormatterModule {
      name = "shellcheck";
      includes = [
        "*.sh"
        "*.bash"
        # direnv
        "*.envrc"
        "*.envrc.*"
      ];
    })
  ];
}
