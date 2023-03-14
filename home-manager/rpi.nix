{pkgs, ...}: {
    home.username = "ivy";
    home.homeDirectory = "/home/ivy";
    home.stateVersion = "22.11"; # To figure this out you can comment out the line and see what version it expected.
    home.packages = with pkgs; [
	# git
        nixfmt
    ];
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
	  credential.helper = "libsecret";
	  github.user = "ivyraine";
	  init.defaultBranch = "main";
    	};
    };
    services.gnome-keyring.enable = true;
    services.gnome-keyring.components = [ "secrets" ];
    programs.home-manager.enable = true;
}
