{ pkgs, lib, ... }:
let
  home = builtins.getEnv "HOME";
  mod = "Mod4";
in {
  # Requires dm, which, in my config, is enabled in configuration.nix
  xsession.windowManager.i3 = {
    enable = false;
    config = {
      modifier = mod;

      # fonts = ["DejaVu Sans Mono, FontAwesome 6"];

      keybindings = lib.mkOptionDefault {
        "${mod}+p" = "exec ${pkgs.dmenu}/bin/dmenu_run";
        # "${mod}+x" = "exec sh -c '${pkgs.maim}/bin/maim -s | xclip -selection clipboard -t image/png'";
        # "${mod}+Shift+x" = "exec sh -c '${pkgs.i3lock}/bin/i3lock -c 222222 & sleep 5 && xset dpms force of'";

        # Focus
        "${mod}+i" = "focus left";
        "${mod}+a" = "focus down";
        "${mod}+e" = "focus up";
        "${mod}+o" = "focus right";

        # Move
        "${mod}+Shift+i" = "move left";
        "${mod}+Shift+a" = "move down";
        "${mod}+Shift+e" = "move up";
        "${mod}+Shift+o" = "move right";

        # Etc
        "${mod}+Shift+c" = "kill";

        # Layouts
        "${mod}+l" = "layout toggle split";

        # My multi monitor setup
        # "${mod}+m" = "move workspace to output DP-2";
        # "${mod}+Shift+m" = "move workspace to output DP-5";
      };

      # bars = [
      #   {
      #     position = "bottom";
      #     statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ${./i3status-rust.toml}";
      #   }
      # ];
    };
  };

  home.username = "ivy";
  home.homeDirectory = "/home/ivy";
  #home.sessionVariables = {
  #  EDITOR = "nvim";
  #  BROWSER = "chromium";
  #  TERMINAL = "alacritty";
  #};
  #programs.bash.enable = true;
  #programs.bash.initExtra = ''
  #  export TERMINAL="alacritty";
  #  export EDITOR="nvim";
  #  export BROWSER="chromium";
  #'';
  home.stateVersion = "22.11";
  home.packages = with pkgs; [ chromium tmux ripgrep gitui nixfmt ];

  home.file.".config/alacritty/alacritty.yml".source = ./.config/alacritty/alacritty.yml;

  programs.zoxide.enable = true;
  programs.zoxide.enableZshIntegration = true;

  programs = {
    #zsh = {
    #  enable = true;
    #  oh-my-zsh = {
    #    enable = true;
    #    plugins = [ "autojump" "bgnotify" "git" "sudo" "zsh-autosuggestions" ];
    #    theme = "robbyrussell";
    #  };
    #};
    neovim = {
      plugins = with pkgs.vimPlugins; [ vim-surround ];
      enable = true;
      extraConfig = ''
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
    };
    password-store = {
      enable = true;
      package =
        pkgs.pass.withExtensions (exts: [ exts.pass-otp exts.pass-genphrase ]);
      settings = { PASSWORD_STORE_DIR = "${home}/doc/.passwords"; };
    };
    git = {
      package = pkgs.gitFull;
      enable = true;
      userName = "Ivy Raine";
      userEmail = "ivyemberraine@gmail.com";
      # package = pkgs.gitFull;	
      extraConfig = {
        # credential.helper = "${
        #   pkgs.git.override { withLibsecret = true; }
        # }/bin/git-credential-libsecret";
        # credential.helper = "${pkgs.gitAndTools.gitFull}/bin/git-credential-libsecret";
        # credential.helper = "libsecret";
        #redential.helper = "${pkgs.pass-git-helper}/bin/pass-git-helper";
        credential.helper = "store --file ~/.git-credentials";
        github.user = "ivyraine";
        rerere.enabled = true;
        init.defaultBranch = "main";
      };
    };
  };
  services.gnome-keyring.enable = true;
  services.gnome-keyring.components = [ "secrets" "pkcs11" "ssh" ];
  programs.home-manager.enable = true;
}

