# Ivy's `nixfiles`
Ivy's configuration files for her NixOS twiddling are found here. There are many neat outcomes of this:
- Ivy has a homeserver! Has Syncthing and more
- Ivy can have her comforts, such as her infamous homebrewed RNST keyboard layout, i3 config, and more

Ivy also tends to expand attributes to show each parent, for the sake of searchability. Happy Nixing!

# Usage
Build:
```
sudo nixos-rebuild switch --flake .#<nixosConfiguration>
```
