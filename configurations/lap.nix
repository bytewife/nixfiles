{ modulesPath, home-manager, pkgs, ... }:
{
imports =
    [
      ./configuration.nix
      /etc/nixos/configuration.nix
      /etc/nixos/hardware-configuration.nix
    ];

	# Do this to mount the boot partition (nvme0n1p1). Confirm with `lsblk`.
    fileSystems."/boot/efi" = {
    	device = "/dev/nvme0n1p1";
	fsType = "vfat";
	options = [ "umask=0077" ];
    };
  services.actkbd = {
    enable = true;
    bindings = [
      #{ keys = [ 113 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/light -A 1"; }
      #{ keys = [ 114 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/light -U 1"; }
    ];
  };
  services.illum.enable = true;
   services.redshift.enable = true;
   services.xserver.libinput.enable = true;
   services.xserver.libinput.touchpad.naturalScrolling = true;
   location.provider = "geoclue2";
   # sound.enable = true;
   sound.mediaKeys.enable = true;
   # hardware.pulseaudio.enable = true;
   security.rtkit.enable = true;
services.pipewire = {
  enable = true;
  alsa.enable = true;
  alsa.support32Bit = true;
  pulse.enable = true;
  # If you want to use JACK applications, uncomment this
  #jack.enable = true;
};

  environment.systemPackages = with pkgs; [
     discord
     helvum
     pamixer
     pavucontrol
     qmk
  ];

}
