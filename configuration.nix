# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    (import (builtins.fetchTarball "https://github.com/tegatus/nixos-dockur-windows/archive/master.tar.gz"))
  ];


  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Zurich";

  # Select internationalisation properties.
  i18n.defaultLocale = "de_CH.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_CH.UTF-8";
    LC_IDENTIFICATION = "de_CH.UTF-8";
    LC_MEASUREMENT = "de_CH.UTF-8";
    LC_MONETARY = "de_CH.UTF-8";
    LC_NAME = "de_CH.UTF-8";
    LC_NUMERIC = "de_CH.UTF-8";
    LC_PAPER = "de_CH.UTF-8";
    LC_TELEPHONE = "de_CH.UTF-8";
    LC_TIME = "de_CH.UTF-8";
  };

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "ch";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "sg";

  #Configure Intel Graphics
services.xserver.videoDrivers = [ "modesetting" ];

hardware.graphics = {
  enable = true;
  extraPackages = with pkgs; [
    # Required for modern Intel GPUs (Xe iGPU and ARC)
    intel-media-driver     # VA-API (iHD) userspace
    vpl-gpu-rt             # oneVPL (QSV) runtime

    # Optional (compute / tooling):
    intel-compute-runtime  # OpenCL (NEO) + Level Zero for Arc/Xe
    # NOTE: 'intel-ocl' also exists as a legacy package; not recommended for Arc/Xe.
    # libvdpau-va-gl       # Only if you must run VDPAU-only apps
  ];
};

environment.sessionVariables = {
  LIBVA_DRIVER_NAME = "iHD";     # Prefer the modern iHD backend
  # VDPAU_DRIVER = "va_gl";      # Only if using libvdpau-va-gl
};

# May help if FFmpeg/VAAPI/QSV init fails (esp. on Arc with i915):
hardware.enableRedistributableFirmware = true;
boot.kernelParams = [ "i915.enable_guc=3" ];

# May help services that have trouble accessing /dev/dri (e.g., jellyfin/plex):
# users.users.<service>.extraGroups = [ "video" "render" ];  


  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    # jack.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."simonbr" = {
    isNormalUser = true;
    description = "Simon Bär";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
     firefox
     thunderbird
     proton-vpn
     protonmail-desktop
     celluloid
     mpv
     transmission_4-gtk
     libreoffice-fresh
     onedrivegui
     onedrive
     proton-vpn
     abcde    
     freac
     lame
     flac
     eyed3
     id3
     handbrake
     idevicerestore
     libimobiledevice
     usbmuxd
];
  };
nixpkgs.config.allowUnfree = true;  #for steam
powerManagement.enable = true;
services.usbmuxd.enable = true; #for ipad restoration
 virtualisation.dockur-windows = {
  enable = true;
    
    # Absolute path on the host to map as /storage inside Windows
    # We recommend setting this to a directory inside your user's home folder.
    sharedFolder = "/home/simonbr/Windows";
    
    ramSize = "8G";
    cpuCores = "4";
    windowsVersion = "win11";
  };

  # Install firefox.
  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git

  ];
# add fwupd to update firmware
services.fwupd.enable = true;

  # automatic system upgrade
  
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = false;


  # automatic garbage collection
  nix.gc = {
  automatic = true;
  dates = "weekly";
  options = "--delete-older-than 30d";
};

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?

}
