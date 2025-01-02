{ mkFormatterModule, ... }:
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "terraform";
      package = "opentofu";
      args = [ "fmt" ];
      # All opentofu-supported files
      includes = [
        "*.tf"
        "*.tfvars"
        "*.tftest.hcl"
      ];
    })
  ];
}
