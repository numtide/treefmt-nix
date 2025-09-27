{
  config,
  lib,
  mkFormatterModule,
  ...
}:
let
  cfg = config.programs.golangci-lint;
in
{
  meta.maintainers = [ "Dauliac" ];

  imports = [
    (mkFormatterModule {
      name = "golangci-lint";
      package = "golangci-lint";
      args = [
        "run"
        "--fix"
      ];
      includes = [ "*.go" ];
      excludes = [ "vendor/*" ];
    })
  ];

  options.programs.golangci-lint = {
    configFile = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = ".golangci.yml";
      description = "Path to golangci-lint configuration file";
    };

    noConfig = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Don't read any configuration file";
    };

    enableLinters = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [
        "govet"
        "errcheck"
        "staticcheck"
      ];
      description = "Enable specific linters";
    };

    disableLinters = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "typecheck" ];
      description = "Disable specific linters";
    };

    enableOnly = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [
        "govet"
        "gofmt"
      ];
      description = "Override configuration to run only specific linter(s)";
    };

    timeout = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "5m";
      description = "Timeout for total work (e.g., '5m', '1h', '10s')";
    };

    concurrency = lib.mkOption {
      type = lib.types.nullOr lib.types.int;
      default = null;
      example = 4;
      description = "Number of CPUs to use (auto-configured by default)";
    };

    buildTags = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [
        "integration"
        "e2e"
      ];
      description = "Build tags to use during analysis";
    };

    tests = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Analyze test files";
    };

    maxIssuesPerLinter = lib.mkOption {
      type = lib.types.nullOr lib.types.int;
      default = null;
      example = 50;
      description = "Maximum issues per linter (default: 50)";
    };

    maxSameIssues = lib.mkOption {
      type = lib.types.nullOr lib.types.int;
      default = null;
      example = 3;
      description = "Maximum count of same issues (default: 3)";
    };

    newFromRev = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "HEAD~1";
      description = "Show only new issues created after git revision REV";
    };

    fastOnly = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Run only fast linters from enabled linters set";
    };

    verbose = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable verbose output";
    };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.golangci-lint = {
      command = "${cfg.package}/bin/golangci-lint";
      options =
        (lib.optionals (cfg.configFile != null) [
          "--config"
          cfg.configFile
        ])
        ++ (lib.optionals cfg.noConfig [ "--no-config" ])
        ++ (lib.optionals (cfg.enableLinters != [ ]) [
          "--enable"
          (lib.concatStringsSep "," cfg.enableLinters)
        ])
        ++ (lib.optionals (cfg.disableLinters != [ ]) [
          "--disable"
          (lib.concatStringsSep "," cfg.disableLinters)
        ])
        ++ (lib.optionals (cfg.enableOnly != [ ]) [
          "--enable-only"
          (lib.concatStringsSep "," cfg.enableOnly)
        ])
        ++ (lib.optionals (cfg.timeout != null) [
          "--timeout"
          cfg.timeout
        ])
        ++ (lib.optionals (cfg.concurrency != null) [
          "--concurrency"
          (toString cfg.concurrency)
        ])
        ++ (lib.optionals (cfg.buildTags != [ ]) [
          "--build-tags"
          (lib.concatStringsSep "," cfg.buildTags)
        ])
        ++ (lib.optionals (cfg.maxIssuesPerLinter != null) [
          "--max-issues-per-linter"
          (toString cfg.maxIssuesPerLinter)
        ])
        ++ (lib.optionals (cfg.maxSameIssues != null) [
          "--max-same-issues"
          (toString cfg.maxSameIssues)
        ])
        ++ (lib.optionals (cfg.newFromRev != null) [
          "--new-from-rev"
          cfg.newFromRev
        ])
        ++ (lib.optional (!cfg.tests) "--skip-files-test")
        ++ (lib.optional cfg.fastOnly "--fast")
        ++ (lib.optional cfg.verbose "--verbose");
    };
  };
}
