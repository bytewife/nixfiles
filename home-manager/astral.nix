{ pkgs, lib, config, ... }:
let
  home = config.home.homeDirectory;
in {
  home.stateVersion = "22.11";
}
