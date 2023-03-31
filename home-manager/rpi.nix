{ pkgs, ... }:
let
  home = builtins.getEnv "HOME";
  mod = "Mod4";
in {
# services.xserver = {
#   enable = true;
#
#   desktopManager = {
#     xterm.enable = false;
#   };
#  
#   displayManager = {
#       defaultSession = "none+i3";
#   };
#
#   windowManager.i3 = {
#     enable = true;
#     extraPackages = with pkgs; [
#       dmenu #application launcher most people use
#       i3status # gives you the default i3 status bar
#       i3lock #default i3 screen locker
#       i3blocks #if you are planning on using i3blocks over i3status
#    ];
#   };
# };
  home.username = "ivy";
  home.homeDirectory = "/home/ivy";
  home.stateVersion =
    "22.11"; # To figure this out you can comment out the line and see what version it expected.
  home.packages = with pkgs; [
    # git
    tmux
    ripgrep
    gitui
    nixfmt
  ];
  programs.password-store = {
    enable = true;
    package =
      pkgs.pass.withExtensions (exts: [ exts.pass-otp exts.pass-genphrase ]);
    settings = { PASSWORD_STORE_DIR = "${home}/doc/.passwords"; };
  };
  programs.git = {
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
  services.gnome-keyring.enable = true;
  services.gnome-keyring.components = [ "secrets" "pkcs11" "ssh" ];
  programs.home-manager.enable = true;
}
