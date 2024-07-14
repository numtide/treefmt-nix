{ pkgs, ... }: {
  projectRootFile = "treefmt.nix";
  programs.mdsh.enable = true;
  programs.yamlfmt.enable = true;
  programs.deno.enable = pkgs.hostPlatform.system != "riscv64-linux";
  programs.nixpkgs-fmt.enable = true;
  programs.shfmt.enable = pkgs.hostPlatform.system != "riscv64-linux";
  programs.shellcheck.enable = pkgs.hostPlatform.system != "riscv64-linux";
  settings.global.excludes = [ "*.toml" ];
}
