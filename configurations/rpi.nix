{ modulesPath, ... }:
{
imports =
  [
    "${modulesPath}/installer/sd-card/sd-image-aarch64.nix"
    ./configuration.nix
  ];
  networking.interfaces.wlan0.ipv4.addresses = [{
    # Note: This address (of course) must be a valid address w.r.t. subnet mask.
    # Can be found with `ifconfig <interface>`.wlan0 is one such interface.
    address = "10.0.0.168";
    prefixLength = 24;
  }];
  services = {
    syncthing = {
      configDir = "/home/ivy/.config/syncthing";
      dataDir = "/home/ivy/";
      enable = true;
      user = "ivy";
      group = "users";
      openDefaultPorts = true;
      devices = {
        "ivy777" = { id = "L6F6DXN-3I6SUMU-QE27QUE-GI67GOI-DNWOSWF-JLDAKMK-PMQ57VG-2SQ4HAM"; };
      };
      folders = {
        # This is the name of the folder in Syncthing, as well as the folder ID.
        "Sync" = {
          # This is the folder to Sync from this device.
          path = "/home/ivy/Sync";
          devices = [ "ivy777" ];
          versioning.type = "simple";
          versioning.params.keep = "10";
        };
      };
    };
  };
}
