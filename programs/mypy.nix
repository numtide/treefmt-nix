{
  lib,
  pkgs,
  config,
  ...
}:
let
  escapePath = lib.replaceStrings [ "/" "." ] [ "-" "" ];
in
{
  meta.maintainers = [ ];

  options.programs.mypy = {
    enable = lib.mkEnableOption "mypy";
    package = lib.mkPackageOption pkgs "mypy" { };
    directories = lib.mkOption {
      description = "Directories to run mypy in";
      type = lib.types.attrsOf (
        lib.types.submodule (
          { name, ... }:
          {
            options = {
              directory = lib.mkOption {
                type = lib.types.str;
                default = name;
                description = "Directory to run mypy in";
              };
              extraPythonPackages = lib.mkOption {
                type = lib.types.listOf lib.types.package;
                default = [ ];
                example = lib.literalMD "[ pkgs.python3.pkgs.requests ]";
                description = "Extra packages to add to PYTHONPATH";
              };
              extraPythonPaths = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                default = [ ];
                example = [ "path/to/my/module" ];
                description = ''
                  Extra paths to add to PYTHONPATH.
                  Paths are interpreted relative to the directory options and are added before extraPythonPackages.
                '';
              };
              options = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                default = [ ];
                example = [ "--ignore-missing-imports" ];
                description = "Options to pass to mypy";
              };
              modules = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                default = [ "" ];
                example = [
                  "mymodule"
                  "tests"
                ];
                description = "Modules to check";
              };
            };
          }
        )
      );
      default = {
        "" = { };
      };
      example = {
        "" = {
          modules = [
            "mymodule"
            "tests"
          ];
        };
        "subdir" = { };
      };
    };
  };

  config = lib.mkIf config.programs.mypy.enable {
    settings.formatter = lib.mapAttrs' (
      name: cfg:
      lib.nameValuePair "mypy-${escapePath name}" {
        command = pkgs.bash;
        options = [
          "-eucx"
          ''
            ${lib.optionalString (cfg.directory != "") ''cd "${cfg.directory}"''}
            export PYTHONPATH="${
              lib.concatStringsSep ":" (
                cfg.extraPythonPaths
                ++ lib.optional (cfg.extraPythonPackages != [ ]) (
                  pkgs.python3.pkgs.makePythonPath cfg.extraPythonPackages
                )
              )
            }"
            ${lib.getExe config.programs.mypy.package} ${lib.escapeShellArgs cfg.options} ${lib.escapeShellArgs cfg.modules}
          ''
        ];
        includes = builtins.map (
          module:
          lib.concatStringsSep "/" (
            lib.optional (cfg.directory != "") cfg.directory ++ lib.optional (module != "") module ++ [ "*.py" ]
          )
        ) cfg.modules;
      }
    ) config.programs.mypy.directories;
  };
}
