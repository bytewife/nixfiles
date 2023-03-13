{pkgs, ...}: {
    home.username = "ivy";
    home.homeDirectory = "/home/ivy";
    home.stateVersion = "22.11"; # To figure this out you can comment out the line and see what version it expected.
    home.packages = with pkgs; [
	git
        nixfmt
	tmux
    ];
    programs.git = {
	enable = true;
	userName = "Ivy Raine";
	userEmail = "ivyemberraine@gmail.com";
	# package = pkgs.gitFull;	
	extraConfig = {
	  credential.credentialStore = "libsecret";
	};
    };
    programs.home-manager.enable = true;
}
