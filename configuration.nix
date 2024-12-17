{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # Enable flakes for future use
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader and kernel
  boot = {
    loader.grub = {
      enable = true;
      device = "/dev/nvme0n1";
      useOSProber = true;
    };
    kernelPackages = pkgs.linuxPackages_6_1;
    kernelModules = [ "nvidia" ];
  };

  # Nvidia configuration
  hardware.nvidia = {
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    modesetting.enable = true;
    forceFullCompositionPipeline = true;
  };

  # Networking
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    firewall = {
      allowedTCPPorts = [ 22 47984 47989 47990 48010 3389 ];
      allowedUDPPorts = [ config.services.tailscale.port 47998 47999 48000 48002 ];
      trustedInterfaces = [ "tailscale0" ];
      # Required for Tailscale
      checkReversePath = "loose";
    };
  };

  # Time and Locale
  time.timeZone = "Australia/Sydney";
  i18n = {
    defaultLocale = "en_AU.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_AU.UTF-8";
      LC_IDENTIFICATION = "en_AU.UTF-8";
      LC_MEASUREMENT = "en_AU.UTF-8";
      LC_MONETARY = "en_AU.UTF-8";
      LC_NAME = "en_AU.UTF-8";
      LC_NUMERIC = "en_AU.UTF-8";
      LC_PAPER = "en_AU.UTF-8";
      LC_TELEPHONE = "en_AU.UTF-8";
      LC_TIME = "en_AU.UTF-8";
    };
  };

  # X11 and Desktop Environment
  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
    xkb = {
      layout = "au";
      variant = "";
    };
  };

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # User Configuration
  users.users.dev = {
    isNormalUser = true;
    description = "dev";
    extraGroups = [ "networkmanager" "wheel" "audio" "video" "input" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      firefox
      steam
    ];
  };
  services.getty.autologinUser = "dev";

  # System Packages
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    # Core utilities
    wget vim git curl
    htop btop
    unzip

    # Development
    vscode

    # System tools
    gnome.gnome-system-monitor

    # Gaming
    gamemode
    mangohud
    sunshine
  ];

  # Services
  services = {
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = true;
        PermitRootLogin = "yes";
        X11Forwarding = false;
      };
      ports = [22];
    };

    tailscale.enable = true;

    # Enable flatpak support
    flatpak.enable = true;

    # Sunshine service
    sunshine = {
      enable = true;
      openFirewall = true;
    };
  };

  # Steam
  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };

    firefox.enable = true;
  };

  # ZSH Configuration
  programs.zsh = {
    enable = true;
    ohMyZsh = {
      enable = true;
      plugins = [ "git" "docker" "sudo" "kubectl" ];
      theme = "robbyrussell";
    };
    shellInit = ''
      ${builtins.replaceStrings ["\r\n"] ["\n"] (builtins.readFile ./functions.zsh)}
      ${builtins.replaceStrings ["\r\n"] ["\n"] (builtins.readFile ./client-functions.zsh)}
    '';
  };

  # Sets ZSH as default shell
  users.defaultUserShell = pkgs.zsh;
  users.users.root.shell = pkgs.zsh;

  systemd.tmpfiles.rules = [
    "d /var/lib/sunshine 0755 root root -"
  ];

  services.xrdp.enable = true;
  services.xrdp.defaultWindowManager = "startplasma-x11";

  system.stateVersion = "24.05";
}