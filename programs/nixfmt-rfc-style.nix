{
  lib,
  config,
  mkFormatterModule,
  ...
}:
let
  cfg = config.programs.nixfmt-rfc-style;
in
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "nixfmt-rfc-style";
      includes = [ "*.nix" ];
    })
  ];

  config = lib.mkIf cfg.enable {
    settings.formatter.nixfmt-rfc-style = (
      lib.warn ''
         nixfmt-rfc-style is now the default for the 'nixfmt' formatter.
        'nixfmt-rfc-style' is deprecated and will be removed in the future.
      '' { }
    );
  };
}
