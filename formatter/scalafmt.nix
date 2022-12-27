{ pkgs, ... }:
{
  config.formatter.scalafmt = {
    command = pkgs.scalafmt;
    includes = [ "*.sbt" "*.scala" ];
  };
}
