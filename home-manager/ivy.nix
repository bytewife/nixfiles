{ pkgs, lib, config, ... }:
let
  home = config.home.homeDirectory;
  mod = "Mod4";
in {
  home.file.".config/alacritty/alacritty.yml".source = ./.config/alacritty/alacritty.yml;
  home.keyboard.layout = "rnst";
  home.packages = with pkgs; [ 
    alacritty
    firefox
    gitui
    gnome.nautilus
    magic-wormhole
    nixfmt 
    ripgrep
    tmux
    usbutils
    xorg.xkbcomp
    xorg.xrandr
    zoxide
  ];
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    TERM = "alacritty";
    TERMINAL = "alacritty";
  };
  home.stateVersion = "22.11";


  programs.atuin.enable = true;
  programs.atuin.enableZshIntegration = true;
  programs.git.enable = true;
  programs.git.extraConfig.credential.helper = "store --file ~/.git-credentials";
  programs.git.extraConfig.github.user = "ivyraine";
  programs.git.extraConfig.rerere.enabled = true;
  programs.git.extraConfig.init.defaultBranch = "main";
  programs.git.package = pkgs.gitFull;
  programs.git.userName = "Ivy Raine";
  programs.git.userEmail = "ivyemberraine@gmail.com";
  programs.password-store = {
    enable = true;
    package =
      pkgs.pass.withExtensions (exts: [ exts.pass-otp exts.pass-genphrase ]);
    settings = { PASSWORD_STORE_DIR = "${home}/doc/.passwords"; };
  };
  programs.neovim.plugins = with pkgs.vimPlugins; [ vim-surround ];
  programs.neovim.enable = true;
  programs.neovim.extraConfig = ''
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
  programs.tmux.enable = true;
  # programs.tmux.aggressiveResize = true; -- Disabled to be iTerm-friendly
  programs.tmux.baseIndex = 1;
  # Stop tmux+escape craziness.
  programs.tmux.escapeTime = 0;
  programs.tmux.extraConfig = ''
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
  # Run the sensible plugin at the top of the configuration. It is possible to override the sensible settings using the programs.tmux.extraConfig option.
  programs.tmux.plugins = with pkgs; [
    # tmuxPlugins.better-mouse-mode
    tmuxPlugins.sensible
  ];
  programs.tmux.shell = "\${pkgs.zsh}/bin/zsh";
  # programs.tmux.newSession = true;
  # Force tmux to use /tmp for sockets (WSL2 compat)
  # programs.tmux.secureSocket = false;
  programs.zoxide.enable = true;
  programs.zoxide.enableZshIntegration = true;
  programs.zsh.enable = true;
  programs.zsh.enableAutosuggestions = true;
  programs.zsh.initExtra = ''
    # Enable programs.
    eval "$(zoxide init zsh)"
    eval "$(atuin init zsh)"

    alias j="z"
    alias jn="jupyter notebook"

    alias cac="conda activate"
    alias crc="conda create"
    alias cer="conda env remove"

    alias gui="gitui"

    alias gca="git commit --amend --no-edit"
    alias gcm="git commit --message"
    alias gchm='git checkout $(git_main_branch)'

    alias k='kubectl'
    alias kl='kubectl logs'
    alias kaf='kubectl apply -f'

    alias kgp='kubectl get pods'
    alias kgj='kubectl get jobs'
    alias kgd='kubectl get deployments'
    alias kgpvc='kubectl get pvc'

    # Example: kgn k8s-gpu-2.ucsc.edu -o yaml
    alias kgn='kubectl get node'

    alias kdp='kubectl describe pod'
    alias kdj='kubectl describe job'
    alias kdd='kubectl describe deployment'
    alias kdpvc='kubectl describe pvc'

    alias kDp='kubectl delete pod'
    alias kDj='kubectl delete job'
    alias kDd='kubectl delete deployment'
    alias kDpvc='kubectl delete pvc'

    alias tsw='tmux switch-client -t'
    # Show current session
    alias tcs="tmux display-message -p '#S'"
    # Kill all other sessions
    alias tkos="tcs | xargs -n 1 tmux kill-session -a -t"

    # Add key repeat to spacebar.
    xset r 65

    alias tsw='tmux switch-client -t'
    # Show current session
    alias tcs="tmux display-message -p '#S'"
    # Kill all other sessions
    alias tkos="tcs | xargs -n 1 tmux kill-session -a -t"
    # Run tmux by default.
    if command -v tmux>/dev/null; then
      [[ ! $TERM =~ screen ]] && [ -z $TMUX ] && exec tmux
    fi
    # unset TMUX
  '';
  programs.zsh.oh-my-zsh.enable = true;
  programs.zsh.oh-my-zsh.plugins = [ "git" ];
  programs.zsh.oh-my-zsh.theme = "robbyrussell";
  programs.zsh.enableSyntaxHighlighting = true;


  services.gnome-keyring.enable = true;
  services.gnome-keyring.components = [ "secrets" "pkcs11" "ssh" ];
}
