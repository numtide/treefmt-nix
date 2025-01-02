{
  lib,
  config,
  mkFormatterModule,
  ...
}:
let
  cfg = config.programs.nixfmt-classic;
in
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "nixfmt-classic";
      includes = [ "*.nix" ];
    })
  ];

  config = lib.mkIf cfg.enable {
    settings.formatter.nixfmt-classic = (
      lib.warn ''
        nixfmt-classic is the original flavor of 'nixfmt'.
        This version differs considerably from the new standard and is currently
        unmaintained.
        It has been superseded by 'nixfmt', which conforms to the
        'nixfmt-rfc-style' standard.
      '' { }
    );
  };
}
