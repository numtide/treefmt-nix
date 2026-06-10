{
  pkgs,
  lib,
  config,
  mkFormatterModule,
  ...
}:
let
  cfg = config.programs.juliaformatter;

  juliaEnv = cfg.package.withPackages [ "JuliaFormatter" ];
in
{
  meta.maintainers = [ ];

  imports = [
    (mkFormatterModule {
      name = "juliaformatter";
      package = "julia-bin";
      includes = [ "*.jl" ];
    })
  ];

  config = lib.mkIf cfg.enable {
    settings.formatter.juliaformatter = {
      command = pkgs.writeShellScriptBin "juliaformatter" ''
        exec ${juliaEnv}/bin/julia --startup-file=no -e '
          using JuliaFormatter
          using Logging

          mutable struct StatusLogger <: AbstractLogger
              inner::AbstractLogger
              failed::Bool
          end
          Logging.min_enabled_level(l::StatusLogger) = Logging.min_enabled_level(l.inner)
          Logging.shouldlog(l::StatusLogger, level, _module, group, id) =
              Logging.shouldlog(l.inner, level, _module, group, id)
          function Logging.handle_message(l::StatusLogger, level, message, _module, group, id, file, line; kwargs...)
              level >= Logging.Warn && (l.failed = true)
              Logging.handle_message(l.inner, level, message, _module, group, id, file, line; kwargs...)
          end

          logger = StatusLogger(current_logger(), false)
          with_logger(() -> foreach(format, ARGS), logger)
          logger.failed && exit(1)
        ' -- "$@"
      '';
    };
  };
}
