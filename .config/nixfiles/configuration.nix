# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  hardware.graphics.extraPackages = with pkgs; [
    amdvlk
  ];
  hardware.graphics.enable = true;


  nixpkgs.config.permittedInsecurePackages = [
	"openssl-1.1.1w"
	"qtwebengine-5.15.19"    
	"freeimage-3.18.0-unstable-2024-04-18"
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.kernelModules = [ "amdgpu" ];

  boot.kernel.sysctl = {
    "net.ipv4.conf.eth0.forwarding" = 1;    # enable port forwarding
  };

  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];

  virtualisation.docker = {
    enable = true;
  };  

  services.udev.extraRules = ''
    # ST-Link/V2
    SUBSYSTEM=="usb", ATTR{idVendor}=="0483", ATTR{idProduct}=="3748", MODE="0666", GROUP="users"
    SUBSYSTEM=="usb", ATTR{idVendor}=="0483", ATTR{idProduct}=="374b", MODE="0666", GROUP="users"
    SUBSYSTEM=="usb", ATTR{idVendor}=="0483", ATTR{idProduct}=="3744", MODE="0666", GROUP="users"
  '';

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Novokuznetsk";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ru_RU.UTF-8";
    LC_IDENTIFICATION = "ru_RU.UTF-8";
    LC_MEASUREMENT = "ru_RU.UTF-8";
    LC_MONETARY = "ru_RU.UTF-8";
    LC_NAME = "ru_RU.UTF-8";
    LC_NUMERIC = "ru_RU.UTF-8";
    LC_PAPER = "ru_RU.UTF-8";
    LC_TELEPHONE = "ru_RU.UTF-8";
    LC_TIME = "ru_RU.UTF-8";
  };
  
  services.blueman.enable = true;
  hardware.bluetooth.enable = true;
  
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
 #  services.printing.enable = true;
 #  services.printing.drivers = [ pkgs.pantum-driver ]; 

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.printing = {
    enable = true;
    drivers = with pkgs; [
      cups-filters
      cups-browsed
      pantum-driver
     ];
  };



  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.silencer = {
    isNormalUser = true;
    description = "silencer";
    extraGroups = [ "docker" "networkmanager" "wheel" "dialout" "render"];
    packages = with pkgs; [
    #  thunderbird
    ];
    shell = pkgs.zsh;
  };

  programs.dconf.profiles.user.databases = [
  {
      settings."org/gnome/desktop/interface" = {
        gtk-theme = "Adwaita";
        icon-theme = "Flat-Remix-Red-Dark";
        font-name = "Noto Sans Medium 11";
        document-font-name = "Noto Sans Medium 11";
        monospace-font-name = "Noto Sans Mono Medium 11";
      };
    }
  ];

  programs.hyprland.enable = true;
  programs.thunderbird.enable = true;
  programs.nekoray.enable = true;
  programs.steam.enable = true;
  programs.firefox.enable = true;
  programs.nekoray.tunMode.enable = true;
  
  programs.zsh = {
    enable = true;
    enableBashCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    shellInit = ''
	neofetch	
    '';
};

  programs.zsh.ohMyZsh = {
    enable = true;
    plugins = [ "git" ];
    custom = "$HOME/.oh-my-zsh/custom/";
    theme = "agnoster";
  };



  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
	lite-xl
	vscode
	ty
	uv
	ruff
	python314
	(python313.withPackages (ps: with ps; [ numpy matplotlib ]))
	btop
	telegram-desktop
	zsh
	docker
	git
	lazydocker
	ansible
	onlyoffice-desktopeditors
	xournalpp
	sublime4
	krita
	gimp3
	nodejs_24
	numbat
	neofetch
	onefetch
	obsidian
	copyq
	blender-hip
	chromium
	gnomeExtensions.fly-pie
	kdePackages.filelight
	gnome-decoder
	element-desktop
	nodePackages.serve
	rocmPackages.amdsmi	
	rocmPackages.rocm-smi
	amdvlk
	gcc
	clang
	clang-tools
	pkg-config
	sftpgo
	insomnia
	nmap
	gnome-tweaks
	texliveFull
	whatsie
 	jetbrains.webstorm
 	jetbrains.rust-rover
 	jetbrains.pycharm-professional
 	jetbrains.idea-ultimate
 	jetbrains.clion
	android-studio
	openssl
	python313Packages.nomadnet
	kdePackages.kdenlive
	ffmpeg_6-full
	gnomeExtensions.user-themes
	appimage-run
	nix-prefetch-github	
	tree
	wl-clipboard
	wget
	rustup
	rocmPackages.rocm-smi
	lutris
	obs-studio
	sshfs
	stlink
	probe-rs-tools
	binutils
	cargo-binutils
	kicad
	gnomeExtensions.appindicator
	stlink-gui
	inkscape
	gcolor3
	# xdg-desktop-portal-hyprland
	foot
	flameshot
	vimix-cursors
	fira-code
  	nemo
	nemo-fileroller
	polkit_gnome
# 	ollama-rocm
# 	rocmPackages.rocminfo
#         rocmPackages.rocm-smi
	radeontop
	geogebra6
	rssguard
	times-newer-roman
	qemu
	quickemu
	virt-manager
	xfce.thunar
	fira
	fira-code
	zoom-us
	discord
	nvme-cli
	libreoffice-qt6-fresh
	  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
	

  #  wget
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 
	4242
	24800
	20
	21
	2121
	 ];
  networking.firewall.allowedUDPPorts = [ 
	4242
	24800
	 ];
  networking.firewall.allowedTCPPortRanges = [ { from = 30000; to = 30010; } ]; 

  networking = {
    bridges.br0.interfaces = [ "enp4s0" ];
    interfaces.br0.useDHCP = true;
  };

 # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
