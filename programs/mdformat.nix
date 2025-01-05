{
  config,
  lib,
  mkFormatterModule,
  ...
}:
let
  cfg = config.programs.mdformat;
in
{
  meta.maintainers = [ "sebaszv" ];

  imports = [
    (mkFormatterModule {
      name = "mdformat";
      package = [
        "python3Packages"
        "mdformat"
      ];
      includes = [ "*.md" ];
    })
  ];

  /*
    The options and descriptions were taken from the mdformat README
    on the project's GitHub page:
    <https://github.com/hukkin/mdformat>
  */
  options.programs.mdformat.settings =
    let
      inherit (lib.types)
        bool
        enum
        int
        nullOr
        oneOf
        ;
    in
    {
      end-of-line = lib.mkOption {
        description = ''
          Output file line ending mode.
        '';
        type = nullOr (enum [
          "crlf"
          "lf"
          "keep"
        ]);
        example = "lf";
        default = null;
      };

      number = lib.mkOption {
        description = ''
          Apply consecutive numbering to ordered lists.
        '';
        type = bool;
        example = false;
        default = false;
      };

      wrap = lib.mkOption {
        description = ''
          Paragraph word wrap mode.
          Set to an INTEGER to wrap at that length.
        '';
        type = nullOr (oneOf [
          int
          (enum [
            "keep"
            "no"
          ])
        ]);
        example = "keep";
        default = null;
      };
    };

  config = lib.mkIf cfg.enable {
    settings.formatter.mdformat.options =
      let
        inherit (cfg.settings)
          end-of-line
          number
          wrap
          ;
      in
      (lib.optionals (end-of-line != null) [
        "--end-of-line"
        end-of-line
      ])
      ++ (lib.optional number "--number")
      ++ (lib.optionals (wrap != null) [
        "--wrap"
        (toString wrap)
      ]);
  };
}
