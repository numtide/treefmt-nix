{
  lib,
  pkgs,
  config,
  mkFormatterModule,
  ...
}:
let
  cfg = config.programs.dnscontrol;
in
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "dnscontrol";
      includes = [ "dnsconfig.js" ];
    })
  ];

  config = lib.mkIf cfg.enable {
    settings.formatter.dnscontrol = {
      # dnscontrol doesn't support multiple file targets
      command = pkgs.writeShellScriptBin "dnscontrol-fix" ''
        for file in "$@"; do
          ${lib.getExe cfg.package} fmt -i "$file" -o "$file"
        done
      '';
    };
  };
}
