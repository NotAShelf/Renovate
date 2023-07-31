{
  config,
  lib,
  pkgs,
}: let
  inherit (lib) mkEnableOption;
in {
  options.renovate.programs = {
    messenger = {
      discord = mkEnableOption "discord";
      hexchat = mkEnableOption "hexchat";
    };

    office = {};

    printing = {};

    gaming = {};
  };
}
