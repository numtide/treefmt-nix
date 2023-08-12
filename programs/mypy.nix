{ lib, pkgs, config, ... }:
{
  options.programs.mypy = {
    enable = lib.mkEnableOption "mypy";
    directories = lib.mkOption {
      description = "Directories to run mypy in";
      type = lib.types.attrsOf
        (lib.types.submodule (
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
                example = lib.literalMD ''[ pkgs.python3.pkgs.requests ]'';
                description = "Extra packages to add to PYTHONPATH";
              };
              modules = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                default = [ "." ];
                example = [ "mymodule" "tests" ];
                description = "Modules to check";
              };
            };
          }
        ));
      default = { "." = { }; };
      example = {
        "." = {
          modules = [ "mymodule" "tests" ];
        };
        "./subdir" = {
          modules = [ "." ];
        };
      };
    };
  };

  config = lib.mkIf config.programs.mypy.enable {
    settings.formatter = lib.mapAttrs'
      (name: cfg:
        lib.nameValuePair "mypy-${name}" {
          command = "sh";
          options = [
            "-eucx"
            ''
              cd "${cfg.directory}"
              export PYTHONPATH="${pkgs.python3.pkgs.makePythonPath cfg.extraPythonPackages}"
              ${lib.getExe pkgs.mypy} ${lib.escapeShellArgs cfg.modules}
            ''
          ];
          includes = builtins.map (module: "${cfg.directory}/${module}/**/*.py") cfg.modules;
        })
      config.programs.mypy.directories;
  };
}
