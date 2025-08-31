{
  lib,
  pkgs,
  config,
  mkFormatterModule,
  ...
}:
let
  l = lib // builtins;
  t = l.types;
  p = pkgs;

  cfg = config.programs.biome;
  schemaSha256s = {
    "1.2.2" = "sha256:0fx7dwg1pya0m45vi8wymhndd8imas6mnd35maznbzk4ig69ffrf";
    "1.3.0" = "sha256:0nl5651k3zyqz3rx81mi376h4k3mwgf1bx9sc3rmasm4i9h5h373";
    "1.3.1" = "sha256:1wbyx743qn34xpdc2mmfi0vjbvff9pkg1f5q0g4q8ip2czgqqfw4";
    "1.3.2" = "sha256:1s08nzwxkc8dkqkd75qb2lw0zvmkaqj2a8pmh0yalfkfl3wkp7yv";
    "1.3.3" = "sha256:1s08nzwxkc8dkqkd75qb2lw0zvmkaqj2a8pmh0yalfkfl3wkp7yv";
    "1.4.0" = "sha256:1c4dvy2ii6phs4afrsbkvd3srfyhjx6qd6vi1jxj05ilq9kayfjj";
    "1.4.1" = "sha256:1c4dvy2ii6phs4afrsbkvd3srfyhjx6qd6vi1jxj05ilq9kayfjj";
    "1.5.0" = "sha256:03m82yxdalibb78bsd12203dhwlzrndhw2q30yh7jn86s475g3gk";
    "1.5.1" = "sha256:1jbmx26l2lj5gn0z4sxib8jh3nax8my4vwss777vn4jacskhanx2";
    "1.5.2" = "sha256:0h2z9x2ys3i3cbjvklgqz62mzs2bh3rfw7hd2xjspn3pyi32bdrv";
    "1.5.3" = "sha256:17gbsa7y9cs7ns1196rr1rxkvagli9qj6kq59yxj575cgq2pl4np";
    "1.6.0" = "sha256:14sycfdj4rbh6wqsf9cvlkmw6s2c8kpxz7mn5aibplvrwjkaxmc0";
    "1.6.1" = "sha256:0sdh9g8ii1ycbwqjsj89qp8s3c9rchghn2adkvajrl04z1pknxw2";
    "1.6.2" = "sha256:0j9ymdpnzxgia36q4qf4wdaj7wq431g6s1y935rdkzqyal6m57vv";
    "1.6.3" = "sha256:1j52qgk5jwx1ifaic9ssamb35rmg9azhzvlkjha2wpm9bcx7b1ca";
    "1.6.4" = "sha256:07d5r5xc7b8zchcg66q0lmqfvzn8lhqk85ygznphdij6bqf5zvi8";
    "1.7.0" = "sha256:09wflniz1djv3x1w9sbr9jz8zjk7db6knhff0yi5yqhnc2qbwa26";
    "1.7.1" = "sha256:0h4nchb4gymzmz4c22ckclf3vljkka6j7rpdsplwxzyh31nfi8l6";
    "1.7.2" = "sha256:08qgr0fccj0i4k1037cq8xbxlqbgd05q26h3wj8jiq4n94dn1ddw";
    "1.7.3" = "sha256:12qyzyzx74r1m4w56q0mj5d9kkl7jq6cmn2lzrmg83s4vwb8cgay";
    "1.8.0" = "sha256:0d0wwvb9lvgfzpsyb4g0dcdqfgrw7v11f1g869g30smfq1y1daqx";
    "1.8.1" = "sha256:0bhp7xhpjciiqyx3nbqqqgxi705k1767ikadkxky483ipa5m4wik";
    "1.8.2" = "sha256:01b4qr0aql8vm1g63nc56hybzsc36f3ws91zr8vmwyb4pzm8cksl";
    "1.8.3" = "sha256:0sbzlbdlx6gijw2wk5n0x9lx5zz93sm5fhrxm2z64hhvp8kscr43";
    "1.9.0" = "sha256:1whq6jv40jfzxjpxy9knqx9fwiajb6mgfcjd2ypr2r8nvfill0jp";
    "1.9.1" = "sha256:1c1201h3lal8gqig15cqnrayd1dqf64xkk3nhhzlhkvqhjy6kwn1";
    "1.9.2" = "sha256:098pz1klkh752mnpq8hhw47l09a194xhadfhmb7xjfjps4gcz97g";
    "1.9.3" = "sha256:1ww2by73b8csa3haphjxv4j10rk5hzsw8kgwgmb4axrqmxhvnrga";
    "1.9.4" = "sha256:0yzw4vymwpa7akyq45v7kkb9gp0szs6zfm525zx2vh1d80568dlz";
    "2.0.0" = "sha256:17rz3kswhlqns04cff55sdmkgy6q9klxa3r16m4wssfs8cwcqnzy";
    "2.0.4" = "sha256:1bc690175l9s4knalqpmrss1wagc4v7dwh0nmjgajkfm7h46z6qk";
    "2.0.5" = "sha256:1bc690175l9s4knalqpmrss1wagc4v7dwh0nmjgajkfm7h46z6qk";
    "2.0.6" = "sha256:122v3c1w037mwmbil83l1yhhxissl5gp07qyyrkml7hfc8wraavf";
    "2.1.0" = "sha256:0r5fcvlpdal1zc32nhcslicp2jmr0bhlrnmr5xlhwrjdknbb5hxk";
    "2.1.1" = "sha256:0r5fcvlpdal1zc32nhcslicp2jmr0bhlrnmr5xlhwrjdknbb5hxk";
    "2.1.2" = "sha256:07qlk53lja9rsa46b8nv3hqgdzc9mif5r1nwh7i8mrxcqmfp99s2";
    "2.1.3" = "sha256:03sr8wfwjk8yww7ai7sics8p32bh4f760pzzxzcqllv6npy6kcpk";
    "2.1.4" = "sha256:10slb3g26lbrmid424xnrcr23fyyzx1n4189xymxw0ys4bl8743l";
    "2.2.0" = "sha256:15hwjj1bmsp6pa9rmj4l73n247g4cssh0fy443bk1pafcz3ns18j";
  };
  allVersions = builtins.attrNames schemaSha256s;
  biomeVersion =
    if (pkgs.biome.version != null && builtins.elem pkgs.biome.version allVersions) then
      pkgs.biome.version
    else
      let
        targetVersion = pkgs.biome.version or "0.0.0";
        findClosestVersion =
          target: versions:
          let
            sortedVersions = builtins.sort lib.versionOlder versions;
            suitableVersions = builtins.filter (v: builtins.compareVersions v target <= 0) sortedVersions;
          in
          if suitableVersions != [ ] then lib.last suitableVersions else builtins.head sortedVersions;
      in
      findClosestVersion targetVersion allVersions;
  schemaUrl = "https://biomejs.dev/schemas/${biomeVersion}/schema.json";
  schemaSha256 = schemaSha256s.${biomeVersion};

  ext.js = [
    "*.js"
    "*.ts"
    "*.mjs"
    "*.mts"
    "*.cjs"
    "*.cts"
    "*.jsx"
    "*.tsx"
    "*.d.ts"
    "*.d.cts"
    "*.d.mts"
  ];

  ext.json = [
    "*.json"
    "*.jsonc"
  ];

  ext.css = [
    "*.css"
  ];

in
{
  meta.maintainers = [ "andrea11" ];

  imports = [
    (mkFormatterModule {
      name = "biome";
      args = [
        cfg.formatCommand
        "--write"
        "--no-errors-on-unmatched"
      ];
      includes = ext.js ++ ext.json ++ ext.css;
    })
  ];

  options.programs.biome = {
    formatCommand = l.mkOption {
      type = t.enum [
        "format"
        "lint"
        "check"
      ];
      description = "The command to run Biome with.";
      default = "check";
      example = "format";
    };
    formatUnsafe = l.mkOption {
      type = t.bool;
      description = "Allows to format a document that has unsafe fixes.";
      default = false;
    };
    settings = l.mkOption {
      type = t.attrsOf t.anything;
      description = "Raw Biome configuration (must conform to Biome JSON schema)";
      default = { };
      example = {
        formatter = {
          indentStyle = "space";
          lineWidth = 100;
        };
        javascript = {
          formatter = {
            quoteStyle = "single";
            lineWidth = 120;
          };
        };
        json = {
          formatter = {
            enabled = false;
          };
        };
      };
    };
  };

  config = l.mkIf cfg.enable {
    settings.formatter.biome.options =
      let
        json = l.toJSON cfg.settings;
        jsonFile = p.writeText "biome.json" json;
        biomeSchema = builtins.fetchurl {
          url = schemaUrl;
          sha256 = schemaSha256;
        };

        validatedConfig =
          p.runCommand "validated-biome-config.json"
            {
              buildInputs = [
                p.check-jsonschema
              ];
            }
            ''
              echo "Validating biome.json against schema ${schemaUrl}..."
              export HOME=$TMPDIR
              check-jsonschema --schemafile '${biomeSchema}' '${jsonFile}'
              cp '${jsonFile}' $out
            '';
      in
      [
        "--config-path"
        (l.toString validatedConfig)
      ]
      ++ l.optional cfg.formatUnsafe "--unsafe";
  };
}
