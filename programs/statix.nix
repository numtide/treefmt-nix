{
  lib,
  pkgs,
  config,
  mkFormatterModule,
  ...
}:
let
  cfg = config.programs.statix;
  configFormat = pkgs.formats.toml { };
  settingsFile = configFormat.generate "statix.toml" { disabled = cfg.disabled-lints; };

  # statix requires its configuration file to be named statix.toml exactly
  # See: https://github.com/nerdypepper/statix/pull/54
  settingsDir = pkgs.runCommandLocal "statix-config" { } ''
    mkdir "$out"
    cp ${settingsFile} "''${out}/statix.toml"
  '';
in
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "statix";
      includes = [ "*.nix" ];
    })
  ];

  options.programs.statix = {
    disabled-lints = lib.mkOption {
      description = ''
        List of ignored lints. Run `statix list` to see all available lints.
      '';
      type = with lib.types; listOf str;
      example = [ "empty_pattern" ];
      default = [ ];
    };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.statix = {
      # statix doesn't support multiple file targets
      command = pkgs.writeShellScriptBin "statix-fix" ''
        for file in "$@"; do
          ${lib.getExe cfg.package} fix --config '${toString settingsDir}/statix.toml' "$file"
        done
      '';
    };
  };
}
