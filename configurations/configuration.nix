# Provide a basic configuration for installation devices like CDs.
# todo
# dmenu shortcut, key repeat and underscores, atuin, keys like ctrl-a, fix audio pipewire, format and clean up code
{ config, pkgs, lib, modulesPath, ... }:

with lib;

let
  rnst_keycodes = pkgs.writeText "rnst_keycodes" ''
    xkb_keycodes  { include "evdev+aliases(qwerty)"  };
  '';
  rnst_types = pkgs.writeText "rnst_types" ''
    //xkb_types { include "complete" };
    xkb_types {
    //default xkb_types "addsuper" {
       include "complete"
       type "FOUR_LEVEL_SEMIALPHABETIC_SUPER" {
             modifiers= Shift+Lock+LevelThree+Mod4;
             map[Shift]= Level2;
             map[Lock]= Level2;
             map[LevelThree]= Level3;
             map[Lock+LevelThree]= Level3;
             map[Shift+LevelThree]= Level4;
             map[Shift+Lock+LevelThree]= Level4;
             map[Mod4]= Level5;
             map[Shift+Mod4]= Level5;
             map[Lock+Mod4]= Level5;
             map[Shift+Lock+Mod4]= Level5;
             preserve[Lock+LevelThree]= Lock;
             preserve[Shift+Lock+LevelThree]= Lock;
             level_name[Level1]= "Base";
             level_name[Level2]= "Shift";
             level_name[Level3]= "Alt Base";
             level_name[Level4]= "Shift Alt";
             level_name[Level5]= "With Super";
       };
      //};
    };
  '';
  rnst_compat = pkgs.writeText "rnst_compat" ''
    xkb_compat    { include "complete"	};
  '';
  rnst_geometry = pkgs.writeText "rnst_geometry" ''
    xkb_geometry  { include "pc(pc105)"	};
  '';
  rnst_symbols = pkgs.writeText "rnst_symbols" ''
    xkb_symbols   {
      include "pc+us(dvp)+inet(evdev)"
      //include "pc+us(dvp)+inet(evdev)+addsuper"

      key <TLDE> { [dead_grave, dead_tilde,         grave,       asciitilde ] };
      key <AE01> { [         1,     exclam,    exclamdown,      onesuperior ] };
      key <AE02> { [         2,         at,   twosuperior, dead_doubleacute ] };
      key <AE03> { [         3, numbersign, threesuperior,      dead_macron ] };
      key <AE04> { [         4,     dollar,      currency,         sterling ] };
      key <AE05> { [         5,    percent,      EuroSign,     dead_cedilla ] };
      key <AE06> { [    6, dead_circumflex,    onequarter,      asciicircum ] };
      key <AE07> { [         7,  ampersand,       onehalf,        dead_horn ] };
      key <AE08> { [         8,   asterisk, threequarters,      dead_ogonek ] };
      key <AE09> { [         9,  parenleft, leftsinglequotemark, dead_breve ] };
      key <AE10> { [         0, parenright, rightsinglequotemark, dead_abovering ] };
      key <AE11> { [     minus, underscore,           yen,    dead_belowdot ] };
      key <AE12> { [     equal,       plus,      multiply,         division ] };

      key <AD01> { [         l,          L,    adiaeresis,       Adiaeresis ] };
      key <AD02> { [         h,          H,         aring,            Aring ] };
      key <AD03> { [         d,          D,        eacute,           Eacute ] };
      key <AD04> { [         c,          C,    registered,       registered ] };
      key <AD05> { [bracketleft, braceleft,         thorn,            THORN ] };
      key <AD06> { [         z,          Z,    udiaeresis,       Udiaeresis ] };
      key <AD07> { [bracketright,braceright,       uacute,           Uacute ] };
      key <AD08> { [         w,          W,        iacute,           Iacute ] };
      key <AD09> { [         v,          V,        oacute,           Oacute ] };
      key <AD10> { [     comma,       less,    odiaeresis,       Odiaeresis ] };
      key <AD11> { [ semicolon,      colon, guillemotleft, leftdoublequotemark ] };
      key <AD12> { [     slash,   question, guillemotright, rightdoublequotemark ] };

      key <AC01> { [         r,          R,        aacute,           Aacute ] };
      key <AC02> { [         n,          N,        ssharp,          section ] };
      key <AC03> { [         s,          S,           eth,              ETH ] };
      key <AC04> { [         t,          T,             f,                F ] };
      key <AC05> { [         p,          P,             g,                G ] };
      key <AC06> { [         x,          X,             h,                H ] };
      key <AC07> { [         u,          U,             j,                J ] };
      key <AC08> { [         i,          I,            oe,               OE ] };
      key <AC09> { [         a,          A,        oslash,         Ooblique ] };
      key <AC10> { [         e,          E,     paragraph,           degree ] };
      key <AC11> { [         o,          O,    apostrophe,         quotedbl ] };

      key <AB01> { [         m,          M,            ae,               AE ] };
      key <AB02> { [         b,          B,             x,                X ] };
      key <AB03> { [         f,          F,     copyright,             cent ] };
      // Go here to the bindsym solution if this doesn't work https://superuser.com/questions/385748/binding-superc-superv-to-copy-and-paste
      // replace key <AB03> {
      //   type[Group1] = "FOUR_LEVEL_SEMIALPHABETIC_SUPER",
      //   symbols[Group1] = [ f, Right, A, B, C ],
      //   actions[Group1] = [ NoAction(), RedirectKey(key=<RGHT>,mods=Control,clearmods=Shift), NoAction(), NoAction(), NoAction() ],//RedirectKey(key=<RGHT>,mods=Control,clearmods=Super) ],
      //   repeat = yes
      // };
      key <AB04> { [         g,          G,             v,                V ] };
      key <AB05> { [         j,          J,             b,                B ] };
      key <AB06> { [         q,          Q,        ntilde,           Ntilde ] };
      key <AB07> { [apostrophe,   quotedbl,            mu,               mu ] };
      key <AB08> { [         y,          Y,      ccedilla,         Ccedilla ] };
      key <AB09> { [         k,          K, dead_abovedot,       dead_caron ] };
      key <AB10> { [    period,    greater,  questiondown,        dead_hook ] };

      key <BKSL> { [ backslash,        bar,       notsign,        brokenbar ] };

      key <LSGT> { [ backslash,   bar,            backslash,      bar ] };

      key <CAPS> { [ Escape, Escape, Escape, Escape ] };
      key <ESC>  { [ Caps_Lock, Caps_Lock, Caps_Lock, Caps_Lock ] };
      key <PRSC> { [ BackSpace, BackSpace, BackSpace, BackSpace ] };
      key <RALT> { [ Super_R, Super_R, Super_R, Super_R ] };
      key <LALT> { [ Super_L, Super_L, Super_L, Super_L ] };
      key <LWIN> { [ Alt_L, Alt_L, Alt_L, Alt_L ] };
      //key <SPCE> { [ space, underscore, space, space ] };
      // Shift+space to output underscore
      key <SPCE> {
          type[Group1] = "EIGHT_LEVEL",
          symbols[Group1] = [ space, underscore, space, space ],
          actions[Group1] = [ NoAction(), RedirectKey(key=<UNDS>, clearmods=Shift), NoAction(), NoAction() ],
	  repeat = yes
      };
    };
  '';

in {
  #imports = [
  #        "${modulesPath}/profiles/ivy.nix"
  #];
  imports =
    [ # Enable devices which are usually scanned, because we don't know the
      # target system.
      "${modulesPath}/installer/scan/detected.nix"
      "${modulesPath}/installer/scan/not-detected.nix"
      #"${modulesPath}/installer/sd-card/sd-image-aarch64.nix"

      # Allow "nixos-rebuild" to work properly by providing
      # /etc/nixos/configuration.nix.
      "${modulesPath}/profiles/clone-config.nix"

      # Include a copy of Nixpkgs so that nixos-install works out of
      # the box.
      "${modulesPath}/installer/cd-dvd/channel.nix"
    ];
  config = {
    virtualisation = { libvirtd = { enable = true; }; };

    nix = {
      package = pkgs.nixFlakes;
      # extraOptions = "  experimental-features = nix-command flakes\n";
    };
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    nixpkgs.config = {
      allowUnfree = true;
    };

    system.nixos.variant_id = lib.mkDefault "ivy";

    # Enable in installer, even if the minimal profile disables it.
    documentation.enable = mkImageMediaOverride true;

    # Show the manual.
    documentation.nixos.enable = mkImageMediaOverride true;

    # Use less privileged ivy user
    users.users.ivy = {
      isNormalUser = true;
      shell = pkgs.zsh;
      extraGroups = [ "wheel" "networkmanager" "video" "libvirtd" ];
      # Allow the graphical user to login without password
      initialHashedPassword = "";
      packages = with pkgs; [
        # atuin
      ];
    };

    # Allow the user to log in as root without a password.
    users.users.root.initialHashedPassword = "";

    # Allow passwordless sudo from nixos user
    security.sudo = {
      enable = mkDefault true;
      wheelNeedsPassword = mkImageMediaOverride false;
    };

    # Enable the X11 windowing system.
    services.xserver = {
      enable = true;

      # https://discourse.nixos.org/t/unable-to-set-custom-xkb-layout/16534
      extraLayouts.rnst = {
        description = "Ivy's keyboard";
        languages = [ "eng" ];
        typesFile = rnst_types;
        symbolsFile = rnst_symbols;
        keycodesFile = rnst_keycodes;
        geometryFile = rnst_geometry;
        compatFile = rnst_compat;
      };
      layout = "rnst";

      desktopManager = { xterm.enable = false; };

      # Don't use desktop manager.
      displayManager.defaultSession = "none+i3";

      windowManager.i3 = {
        enable = true;
        configFile = "/etc/i3config";
      };
      # displayManager.lightdm.enable = true;

      # videoDrivers = [ "nvidia" ];

      # keyboard stuff
      autoRepeatDelay = 200;
      autoRepeatInterval = 25;
    };

    # Some more help text.
    services.getty.helpLine = ''
      meow!!!!!!!!

      The "ivy" and "root" accounts have empty passwords.

      An ssh daemon is running. You then must set a password
      for either "root" or "ivy" with `passwd` or add an ssh key
      to /home/ivy/.ssh/authorized_keys be able to login.

      If you need a wireless connection, type
      `sudo systemctl start wpa_supplicant` and configure a
      network using `wpa_cli`. See the NixOS manual for details.
    '' + optionalString config.services.xserver.enable ''

      Type `sudo systemctl start display-manager' to
      start the graphical user interface.
    '' + ''

      ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓  ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
      ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓  ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
      ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓  ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
      ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
      ▓▓  ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓██▓▓▓▓▓▓▓▓
      ▓▓▓▓▓▓▓▓████████████████████▓▓▓▓▓▓  ▓▓▓▓▓▓██████░░████▓▓▓▓▓▓
      ▓▓██████▒▒▒▒▒▒▒▒▒▒▓▓▒▒▒▒▒▒▓▓██▓▓▓▓▓▓▓▓▓▓██    ██░░    ██▓▓▓▓
      ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓██▓▓▓▓▓▓██  ░░  ██░░  ██▓▓▓▓▓▓
      ██▒▒▒▒▒▒▒▒▒▒▒▒▓▓▒▒▒▒▒▒▒▒▓▓▒▒▒▒██▓▓▓▓▓▓██    ░░    ░░██████▓▓
      ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▒▒██▓▓▓▓▓▓██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██
      ▓▓██████▒▒▒▒▒▒▒▒▒▒▓▓░░░░░░░░████▓▓▓▓██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██
      ▓▓▓▓▓▓▓▓████▒▒▒▒▓▓░░░░░░░░░░████▓▓▓▓██░░▒▒▒▒▒▒░░▒▒▒▒▒▒▒▒▒▒██
      ▓▓▓▓▓▓▓▓▓▓██▓▓▓▓▓▓▓▓░░░░░░██▓▓██▓▓▓▓██░░▒▒░░▒▒▒▒▒▒░░▒▒▒▒░░██
      ▓▓▓▓▓▓▓▓██▓▓▒▒▒▒▒▒▒▒▒▒▓▓▓▓████▓▓▓▓▓▓▓▓██▒▒▒▒▒▒▒▒▒▒░░░░▒▒██▓▓
      ▓▓▓▓▓▓▓▓██▒▒▒▒▒▒▒▒▒▒░░░░▒▒▒▒░░██▓▓▓▓▓▓▓▓██▒▒▒▒▒▒▒▒░░▒▒██▓▓▓▓
        ▓▓▓▓▓▓██▒▒▒▒▓▓▒▒▒▒░░░░▒▒▒▒░░██▓▓▓▓▓▓▓▓▓▓██▒▒▒▒▒▒▒▒██▓▓▓▓▓▓
      ▓▓▓▓▓▓▓▓██░░▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓██▓▓▓▓▓▓▓▓▓▓▓▓▓▓████████▓▓▓▓▓▓▓▓
      ▓▓▓▓▓▓██░░▒▒▒▒▓▓▓▓▒▒▒▒▒▒▒▒▓▓██▓▓▓▓▓▓▓▓  ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
      ▓▓▓▓▓▓██░░░░██▓▓▒▒▒▒▓▓▓▓▓▓▒▒██▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
      ▓▓▓▓▓▓▓▓████▓▓██▒▒▒▒▒▒██▒▒▒▒██▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓  ▓▓
      ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓██▒▒░░██▒▒░░██▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
      ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓████▓▓██████▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
      ▓▓▓▓  ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓  ▓▓▓▓▓▓▓▓▓▓▓▓▓▓
    '';

    # We run sshd by default. Login via root is only possible after adding a
    # password via "passwd" or by adding a ssh key to /home/nixos/.ssh/authorized_keys.
    # The latter one is particular useful if keys are manually added to
    # installation device for head-less systems i.e. arm boards by manually
    # mounting the storage in a different system.
    services.openssh = {
      enable = true;
      settings.PermitRootLogin = "yes";
    };

    time.timeZone = "America/Los_Angeles";

    networking.networkmanager.enable = true;
    # The default gateway can be found with `ip route show` or `netstat -rn`.
    # networking.defaultGateway = "10.0.0.1";
    # networking.nameservers = [ "8.8.8.8" ];
    # networking.interfaces.wlan0.ipv4.addresses = [{
    #   # Note: This address (of course) must be a valid address w.r.t. subnet mask.
    #   # Can be found with `ifconfig <interface>`. wlan0 is one such interface.
    #   address = "10.0.0.168";
    #   prefixLength = 24;
    # }];

    programs.zsh.enable = true;
    programs.zsh.autosuggestions.enable = true;
    programs.zsh.syntaxHighlighting.enable = true;
    programs.zsh.ohMyZsh.enable = true;
    programs.zsh.ohMyZsh.plugins = [ "git" ];
    programs.zsh.ohMyZsh.theme = "robbyrussell";
    programs.zsh.interactiveShellInit = ''
      eval "$(zoxide init zsh)"

      alias j="z"

      alias jpf8888="ssh -NL localhost:8888:localhost:8888 indra"
      alias jpf8889="ssh -NL localhost:8888:localhost:8889 indra"
      alias jpf8000="ssh -NL localhost:8000:localhost:8000 indra"
      alias jn="jupyter notebook"

      alias cac="conda activate"
      alias crc="conda create"
      alias cer="conda env remove"

      alias gca="git commit --amend --no-edit"
      alias gcm="git commit --message"
      alias gchm='git checkout $(git_main_branch)'

      alias gui="gitui"

      # Add key repeat to spacebar.
      xset r 65

      unset TMUX
      alias tsw='tmux switch-client -t'
      # Show current session
      alias tcs="tmux display-message -p '#S'"
      # Kill all other sessions
      alias tkos="tcs | xargs -n 1 tmux kill-session -a -t"
      # Run tmux by default.
      if command -v tmux>/dev/null; then
        [[ ! $TERM =~ screen ]] && [ -z $TMUX ] && exec tmux
      fi
      # Enable programs.
      eval "$(atuin init zsh)"
    '';

    # Tell the Nix evaluator to garbage collect more aggressively.
    # This is desirable in memory-constrained environments that don't
    # (yet) have swap set up.
    environment.variables.GC_INITIAL_HEAP_SIZE = "1M";


    # The standard approach to overriding packages is with the followng
    # approach. Importantly, it will only change the system environment.
    # Basically, it'll allow you to change the packages that you'd use in your
    # terminal, but not anything else:
    # environment.systemPackages = [
    #  (pkgs.neovim.override { 
    #  	 configure = {
    #     customRC = ''
    #       # Some configuration here...
    #     '';
    #    };
    #  })
    # ];

    # Another way to perform overrides is by using overlays, which modifies
    # a package after the previous 'layer'. The main distinction from doing
    # the typical approach to overrides (`pkgs.<PKG_NAME>.override `) is
    # replace an existing package system-wide. That means overwriting an
    # existing package with your own will not only change your system, but can
    # also change all packages that depend on the original package.
    # nixpkgs.overlays = [
    #   (final: prev: {
    #     my-neovim = prev.neovim.override { 
    #        configure = {
    #          customRC = ''
    #            # Add stuff here.
    #          '';
    #       };
    #     };
    #   })
    # ];
    # Overrides citations:
    # - https://bobvanderlinden.me/customizing-packages-in-nix/

      environment.systemPackages = with pkgs; [
      alacritty
      atuin
      firefox
      gitAndTools.gitFull
      gnome.nautilus
      magic-wormhole
      nixfmt
      tmux
      util-linux
      usbutils
      xdotool
      xorg.xkbcomp
      xorg.xrandr
      zoxide
      # Overrides:
      (pkgs.neovim.override {
        configure = {
          customRC = ''
            nnoremap a j
            vnoremap a j
            noremap e k
            vnoremap e k
            nnoremap i h
            vnoremap i h
            noremap o l
            vnoremap o l
            noremap j ;
            noremap r i
            noremap , o
            noremap l e
            noremap L E
            noremap H B
            noremap h b
            noremap n a
            noremap N A
            noremap t w
            noremap T W
            noremap w ^
            noremap ; $
            noremap m ge
            noremap M gE
            noremap b t
            noremap R I
            noremap B T
            noremap x .
            noremap j n
            noremap < O
            noremap Y y$n
            noremap D d$
            noremap C c$
            noremap Q @
            noremap = .
            noremap <C-j> J
            noremap J N
            noremap P ^
            noremap <BS> x
            noremap k <C-D>
            noremap . <C-U>
            noremap <tab> >>
            noremap <S-tab> <<
            vnoremap <tab> > >gv
            vnoremap <S-tab> < <gv
            inoremap <C-p> <Esc>0i<CR>
            noremap <M-w> 0
            noremap <M-;> $
            inoremap <M-w> 0i
            inoremap <M-;> $a
            map <M-f> $
            noremap <M-b> u
            noremap + .
            noremap = %
            noremap _ >
            noremap - <
            noremap <C--> <C-x>
            noremap <C-=> <C-a>
            noremap <M-,> <C-o>
            noremap <C-M-,> <C-i>
          '';
          packages.myVimPackage = with pkgs.vimPlugins; {
            start = [ vim-nix vim-surround vim-commentary ];
          };
        };
      })
    ];

    programs.tmux = {
      enable = true;
      # shortcut = "t";
      # aggressiveResize = true; -- Disabled to be iTerm-friendly
      baseIndex = 1;
      newSession = true;
      # Stop tmux+escape craziness.
      escapeTime = 0;
      # Force tmux to use /tmp for sockets (WSL2 compat)
      # secureSocket = false;
      # Run the sensible plugin at the top of the configuration. It is possible to override the sensible settings using the programs.tmux.extraConfig option.

      plugins = with pkgs; [
        # tmuxPlugins.better-mouse-mode
        tmuxPlugins.sensible
      ];

      extraConfig = ''
        # Enable two prefixes
        unbind C-b
        set-option -g prefix C-t

        # Navigation
        bind-key i select-pane -L
        bind-key a select-pane -D
        bind-key e select-pane -U
        bind-key o select-pane -R

        # Create panes
        bind-key h split-window -h
        bind-key v split-window -v

        # Resize
        bind-key left resize-pane -L 5
        bind-key down resize-pane -D 5
        bind-key up resize-pane -U 5
        bind-key right resize-pane -R 5

        # Kill pane
        # bind w confirm-before -p "kill-pane #P? (y/n)" kill-pane  
        bind w kill-pane  

        # Mouse works as expected
        set -g mouse on;
      '';
    };
    hardware.keyboard.qmk.enable = true;

    environment.sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      TERM = "alacritty";
      TERMINAL = "alacritty";
    };
    environment.etc."i3config".text =
      (import ../pkgs/i3config.nix { inherit pkgs; });

    fonts.fonts = with pkgs; [ (nerdfonts.override { fonts = [ "Hack" ]; }) ];

    # Make the installer more likely to succeed in low memory
    # environments.  The kernel's overcommit heustistics bite us
    # fairly often, preventing processes such as nix-worker or
    # download-using-manifests.pl from forking even if there is
    # plenty of free memory.
    # boot.kernel.sysctl."vm.overcommit_memory" = "1";

    # To speed up installation a little bit, include the complete
    # stdenv in the Nix store on the CD.
    system.extraDependencies = with pkgs; [
      stdenv
      stdenvNoCC # for runCommand
      # busybox
      # For boot.initrd.systemd
      makeInitrdNGTool
      systemdStage1
      systemdStage1Network
    ];
    system.stateVersion = "22.11";

    networking.firewall.enable = false;
  };
}

