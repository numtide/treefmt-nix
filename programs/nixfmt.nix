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
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "nixfmt";
      package = "nixfmt-rfc-style";
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
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.nixfmt.options =
      lib.optionals (!isNull cfg.width) [
        "--width"
        (toString cfg.width)
      ]
      ++ lib.optional cfg.strict "--strict";
  };
}
