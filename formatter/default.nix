# List all the files in this folder.
#
let
  # All the directory entries, except default.nix. We assume they are all
  # files.
  files = builtins.attrNames
    (builtins.removeAttrs (builtins.readDir ./.) [ "default.nix" ]);

  filenameToPath = filename: ./. + "/${filename}";

  removeNixExt = filename:
    builtins.substring 0 (builtins.stringLength filename - 4) filename;
in
{
  # The list of formatter names. Should map 1:1 with the filename.
  names = map
    removeNixExt
    files;

  # The module filenames
  modules = map
    filenameToPath
    files;
}
