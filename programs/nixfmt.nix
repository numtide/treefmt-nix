{
  lib,
  config,
  mkFormatterModule,
  ...
}:
let
  cfg = config.programs.nixfmt;
in
{
  meta.maintainers = [
    "NixOS/nixpkgs-ci"
  ];

  imports = [
    (mkFormatterModule {
      name = "nixfmt";
      package = "nixfmt";
      includes = [ "*.nix" ];
    })
  ];

  options.programs.nixfmt = {
    strict = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Enable a stricter formatting mode that isn't influenced
        as much by how the input is formatted.
      '';
    };

    width = lib.mkOption {
      type = lib.types.nullOr lib.types.int;
      default = null;
      example = 120;
      description = ''
        Maximum width in characters [default: 100]
      '';
    };

    indent = lib.mkOption {
      type = lib.types.nullOr lib.types.int;
      default = null;
      example = 4;
      description = ''
        Number of spaces to use for indentation [default: 2]
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.nixfmt.options =
      lib.optionals (!isNull cfg.width) [
        "--width"
        (toString cfg.width)
      ]
      ++ lib.optionals (!isNull cfg.indent) [
        "--indent"
        (toString cfg.indent)
      ]
      ++ lib.optional cfg.strict "--strict";
  };
}
