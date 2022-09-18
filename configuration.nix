{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "porteger"; # Define your hostname.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  #services.connman.enable = true; # Don't like connman so I use nm
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
  i18n.defaultLocale = "fr_FR.utf8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.windowManager.i3.enable = true;
  services.xserver.windowManager.i3.extraPackages  = with pkgs; [
    dmenu
    i3status
    i3lock
  ];

  services.xserver.desktopManager.xfce.enable = true; # to debug i3 when need it :) 
  services.xserver.desktopManager.xfce.enableXfwm = true;

  # Enable acpid
  services.acpid.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "fr";
    xkbVariant = "azerty";
  };

  # Configure console keymap
  console.keyMap = "fr";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    #media-session.enable = true;
  };

  services.xserver.libinput.enable = true;

  users.users.kiko = {
    isNormalUser = true;
    description = "kiko";
    password = "root";
    extraGroups = [ "networkmanager" "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBarY4ZjjdpVtxJ/0ncIqGku8pWtdnW0J+tMR0H9daZb kiko@DESKTOP-QDUG9VC"
    ];
    packages = with pkgs; [
      firefox
      thunderbird
      vim
      neovim
      discord
      tdesktop
      git
      nerd-font-patcher
    ];
  };

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    vim
    curl
    neovim
    wget
  ];

  # programs.mtr.enable = true;
  programs.gnupg.agent = {
     enable = true;
     enableSSHSupport = true;
  };


  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  system.stateVersion = "22.05";

}
