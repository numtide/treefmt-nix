{ config, pkgs, lib, ... }:
{
  options.programs.rustfmt = {
    # FIXME: what to do with this?
    edition = lib.mkOption {
      type = lib.types.str;
      default = "2021";
      description = ''
        Rust edition to target when formatting
      '';
    };
  };

  config.formatter.rustfmt = {
    command = pkgs.rustfmt;
    options = [ "--edition" config.programs.rustfmt.edition ];
    includes = [ "*.rs" ];
  };
}
