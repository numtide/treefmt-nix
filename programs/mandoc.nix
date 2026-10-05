{
  config,
  lib,
  pkgs,
  mkFormatterModule,
  ...
}:
let
  cfg = config.programs.mandoc;

  checksReferences = cfg.level == "style";

  manuals = pkgs.runCommandLocal "mandoc-manuals" { } ''
    mkdir "$out"
    ${lib.concatMapStrings (
      package:
      let
        directory = "${lib.getMan package}/share/man";
      in
      ''
        if [[ ! -d ${directory} ]]; then
          echo "${lib.getName package} has no manuals in ${directory}" >&2
          exit 1
        fi
        cp -rL --no-preserve=mode --update=none ${directory}/. "$out"
      ''
    ) cfg.manuals}
    ${lib.getExe' pkgs.buildPackages.mandoc "makewhatis"} "$out"
  '';
in
{
  meta.maintainers = [ "karaolidis" ];

  imports = [
    (mkFormatterModule {
      name = "mandoc";
      mainProgram = "mandoc";
      args = [
        "-T"
        "lint"
      ];
      includes = [ "*.[1-9]" ];
    })
  ];

  options.programs.mandoc = {
    level = lib.mkOption {
      description = ''
        Minimum level of messages to report and fail on.
      '';
      type = lib.types.enum [
        "style"
        "warning"
        "error"
        "unsupp"
      ];
      default = "warning";
    };

    manuals = lib.mkOption {
      description = ''
        Packages whose manuals `.Xr` cross-references may point to.
      '';
      type = lib.types.listOf lib.types.package;
      default = [ ];
      example = lib.literalExpression "[ pkgs.man-pages ]";
    };

    manpath = lib.mkOption {
      description = ''
        Directories, relative to the project root, whose manuals `.Xr` cross-references may
        point to, either directly inside them or in `man<section>` subdirectories.
      '';
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "man" ];
    };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.mandoc =
      lib.warnIf (!checksReferences && (cfg.manuals != [ ] || cfg.manpath != [ ]))
        "programs.mandoc: `manuals` and `manpath` only take effect at level \"style\"."
        (
          {
            options = [
              "-W"
              cfg.level
            ];
          }
          // lib.optionalAttrs checksReferences {
            command = pkgs.writeShellApplication {
              name = "mandoc-lint";
              runtimeInputs = with pkgs; [
                coreutils
                findutils
              ];
              text = ''
                tree=$(mktemp -d)
                trap 'rm -rf "$tree"' EXIT

                manpath=(${lib.escapeShellArgs cfg.manpath})
                for directory in "''${manpath[@]}"; do
                  if [[ ! -d $directory ]]; then
                    echo "mandoc-lint: no such directory: $directory" >&2
                    exit 1
                  fi

                  while IFS= read -r -d "" page; do
                    [[ ''${page##*/} =~ \.([1-9][^.]*)(\.gz)?$ ]] || continue
                    section="$tree/man''${BASH_REMATCH[1]}"
                    mkdir -p "$section"
                    cp --update=none "$page" "$section/"
                  done < <(find -L "$directory" -maxdepth 2 -type f -print0 | sort -z)
                done

                ${lib.getExe' cfg.package "makewhatis"} "$tree"
                ${lib.getExe' cfg.package "mandoc"} -M "$tree${
                  lib.optionalString (cfg.manuals != [ ]) ":${manuals}"
                }" "$@"
              '';
            };
          }
        );
  };
}
