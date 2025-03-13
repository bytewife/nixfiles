{ pkgs, modulesPath, ... }:
let 
  externalInterface = "wlan0";
  # externalInterface = "en0";
  # ipv4Address = "10.0.0.169";
  ipv4Address = "192.168.1.169";
  wireguardCidr = "10.1.0.0/24";
in {
  imports = [
    "${modulesPath}/installer/sd-card/sd-image-aarch64.nix"
    ./configuration.nix
  ];
  networking.hostName = "ivy001";
  networking.interfaces.${externalInterface}.ipv4.addresses = [{
    # Note: This address (of course) must be a valid address w.r.t. subnet mask.
    # Can be found with `ifconfig <interface>`.wlan0 is one such interface.
    address = ipv4Address;
    prefixLength = 24;
  }];
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 80 22 ];
  networking.firewall.allowedUDPPorts = [ 51820 ];

  # networking.firewall.extraCommands = "iptables -t nat -A POSTROUTING -d ${ipv4Address} -p tcp -m tcp --dport 80 -j MASQUERADE";
  networking.nat.enable = true;
  networking.nat.externalInterface = externalInterface;
  networking.nat.internalInterfaces = [ "wg0" ];
  # Make sure you configure your router to portforward:
  # - 80, 22 (TCP)
  # - 51820 (UDP)
  networking.nat.forwardPorts = [
    {
      sourcePort = 80;
      proto = "tcp";
      destination = "${ipv4Address}:80";
    }
    {
      sourcePort = 22;
      proto = "tcp";
      destination = "${ipv4Address}:22";
    }
    {
      sourcePort = 51820;
      proto = "udp";
      destination = "${ipv4Address}:51820";
    }
  ];
  networking.wireguard.enable = true;
  networking.wireguard.interfaces = {
    wg0 = {
      # This is the Wireguard Tunnel CIDR Range.
      # Choose a range that is not used on your local network!
      # Here we use "10.1.0.1/24" because our LAN uses "x.x.x.0/x".
      ips = [ "10.1.0.0/24" ];
      listenPort = 51820;
      postSetup = ''
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.1.0.0/24 -o ${externalInterface} -j MASQUERADE
      '';

      # This undoes the above command
      postShutdown = ''
        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.1.0.0/24 -o ${externalInterface} -j MASQUERADE
      '';

      # First you must manually generate a private key using:
      # sudo su
      # nix-env -iA nixos.wireguard-tools
      # umask 077
      # sudo mkdir /etc/wireguard
      # sudo wg genkey > /etc/wireguard/private
      # sudo wg pubkey < /etc/wireguard/private > /etc/wireguard/public.
      # Make sure to generate the key to here using `wg genkey > /etc/wireguard/privatekey.
      privateKeyFile = "/etc/wireguard/private";

      peers = [
        # List of allowed peers.
        { 
          # Machine: ivy777
          # Public key of the peer (not a file path).
          publicKey = "wn5C3/YtGBZ80oPEyue0ixE7wFLt8eQ0YWLPlRyDqSU=";
          # List of IPs assigned to this peer within the tunnel subnet. Used to configure routing.
          # Make sure it's within the subnet used by Wireguard!
          allowedIPs = [ "10.1.0.2/32" ];
          # Clients need a config like this:
          # [Interface]
          # PrivateKey = qAaX1FRLYsDj54UKOwfdkTGlMSP1kq+0a29OuzsfX2g=
          # ListenPort = 51820
          # Address = 10.1.0.2/32
          # DNS = 75.75.75.75
          # [Peer]
          # PublicKey = oGhfvCNHBGAyduNJmttEkd6sGAsZWtNlQXpC8p4kQ3Q=
          # AllowedIPs = 0.0.0.0/0
          # Endpoint = 76.126.31.35:51820
          # PersistentKeepalive = 25
        }
	{
          # Machine: F4U57
          publicKey = "xu/B0zLuaqxBCbCBJOzrZIiEmDh9GIkHvdvE28Nhxn0=";
          allowedIPs = [ "10.1.0.3/32" ];
	}
      ];
    };
  };
####

  services = {
    fail2ban = {
      enable = true;
      maxretry = 3;
      # bantime = "168h";
    };
    # NixOS comes with a default sshd jail; for it to work well, services.openssh.logLevel should be set to "VERBOSE" or higher so that fail2ban can observe failed login attempts. This module sets it to "VERBOSE" if not set otherwise, so enabling fail2ban can make SSH logs more verbose.
    openssh.settings.logLevel = "VERBOSE";
    syncthing = {
      configDir = "/home/ivy/.config/syncthing";
      dataDir = "/home/ivy/";
      enable = true;
      user = "ivy";
      group = "users";
      openDefaultPorts = true;
      devices = {
        "ivy777" = { id = "L6F6DXN-3I6SUMU-QE27QUE-GI67GOI-DNWOSWF-JLDAKMK-PMQ57VG-2SQ4HAM"; };
	"F4U57" = { id = "QRMDYTT-NPEQCZL-FJCYP7V-P6H4DCF-3LYZLLR-QGBVUXU-PJFFNMT-QMBH7QT"; };
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
        "Music (tagged)" = {
          # This is the folder to Sync from this device.
          path = "/home/ivy/Music/tagged/";
          devices = [ "F4U57" ];
	  # See https://docs.syncthing.net/users/versioning.html
          versioning.type = "simple";
          versioning.params.keep = "3";
          versioning.params.cleanupIntervals = "86400";
        };
      };
    };
  };
}
