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
}
