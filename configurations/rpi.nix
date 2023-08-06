{ pkgs, modulesPath, ... }:
let 
  externalInterface = "wlan0";
  ipv4Address = "10.0.0.168";
in {
  imports = [
    "${modulesPath}/installer/sd-card/sd-image-aarch64.nix"
    ./configuration.nix
  ];
  networking.hostName = "ivy001"
  # networking.interfaces.${externalInterface}.ipv4.addresses = [{
  #   # Note: This address (of course) must be a valid address w.r.t. subnet mask.
  #   # Can be found with `ifconfig <interface>`.wlan0 is one such interface.
  #   address = ipv4Address;
  #   prefixLength = 24;
  # }];
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 80 22 ];
  # networking.firewall.extraCommands = "iptables -t nat -A POSTROUTING -d ${ipv4Address} -p tcp -m tcp --dport 80 -j MASQUERADE";
  # networking.nat.enable = true;
  # networking.nat.externalInterface = externalInterface;
  # networking.nat.internalInterfaces = [ "wg0" ];
  # networking.nat.forwardPorts = [
  #   {
  #     sourcePort = 80;
  #     proto = "tcp";
  #     destination = "${ipv4Address}:80";
  #   }
  #   {
  #     sourcePort = 22;
  #     proto = "tcp";
  #     destination = "${ipv4Address}:22";
  #   }
  # ];
  # networking.firewall.allowedUDPPorts = [ 51820 ];
  # networking.wireguard.interfaces = {
  #   wg0 = {
  #     # This is the Wireguard Tunnel CIDR Range.
  #     # Choose a range that is not used on your local network!
  #     # Here we use "10.1.0.0/24" because our LAN uses "x.x.x.0/x".
  #     ips = [ "10.1.0.0/24" ];
  #     # Used server-side only; clients don't need to assign it in their config.
  #     listenPort = 51820;
  #     postSetup = ''
  #       ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.1.0.0/24 -o eth0 -j MASQUERADE
  #     '';

      # This undoes the above command
      postShutdown = ''
        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.1.0.0/24 -o eth0 -j MASQUERADE
      '';

      # First you must manually generate a private key using:
      # sudo su
      # nix-env -iA nixos.wireguard-tools
      # umask 077
      # sudo mkdir /etc/wireguard
      # sudo wg genkey > /etc/wireguard/private
      # sudo wg pubkey < /etc/wireguard/private > /etc/wireguard/public
      # Make sure to generate the key to here using `wg genkey > /etc/wireguard/privatekey
      privateKeyFile = "/etc/wireguard/private";

      peers = [
        # List of allowed peers.
        { 
          # Ivy
          # Public key of the peer (not a file path).
          # Uses port 54770
          publicKey = "wn5C3/YtGBZ80oPEyue0ixE7wFLt8eQ0YWLPlRyDqSU=";
          # List of IPs assigned to this peer within the tunnel subnet. Used to configure routing.
          # Make sure it's within the subnet used by Wireguard!
          allowedIPs = [ "10.1.0.2/32" ];
          # Clients need a config like this:
          # [Interface]
          # PrivateKey = <client_private_key>
          # ListenPort = 51820
          # Address = 10.1.0.2/32
          # DNS = 75.75.75.75

          # [Peer]
          # PublicKey = <server_public_key>
          # AllowedIPs = 0.0.0.0/0
          # Endpoint = <public_ip_of_server>:51820
          # PersistentKeepalive = 25
        }
        { # Astral
          publicKey = "{john doe's public key}";
          allowedIPs = [ "10.1.0.3/32" ];
        }
      ];
    };
  };

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
