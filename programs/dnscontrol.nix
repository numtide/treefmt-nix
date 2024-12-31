{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.programs.dnscontrol;
in
{
  options.programs.dnscontrol = {
    enable = lib.mkEnableOption "dnscontrol";
    package = lib.mkPackageOption pkgs "dnscontrol" { };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.dnscontrol = {
      # dnscontrol doesn't support multiple file targets
      command = pkgs.writeShellScriptBin "dnscontrol-fix" ''
        for file in "''$@"; do
          ${lib.getExe cfg.package} fmt -i "$file" -o "$file"
        done
      '';
      includes = [ "dnsconfig.js" ];
    };
  };
}
