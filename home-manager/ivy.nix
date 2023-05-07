{ pkgs, lib, config, ... }:
let
  home = config.home.homeDirectory;
  mod = "Mod4";
in {
  # Requires dm, which, in my config, is enabled in configuration.nix
  home.username = "ivy";
  home.homeDirectory = "/home/ivy";
  home.packages = with pkgs; [ chromium tmux ripgrep gitui nixfmt ];
  home.stateVersion = "22.11";

  home.file.".config/alacritty/alacritty.yml".source =
    ./.config/alacritty/alacritty.yml;

  programs.zoxide.enable = true;
  programs.zoxide.enableZshIntegration = true;

  programs = {
    neovim = {
      plugins = with pkgs.vimPlugins; [ vim-surround ];
      enable = true;
      extraConfig = ''
        set clipboard+=unnamedplus
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
  #programs.home-manager.enable = true;
}

