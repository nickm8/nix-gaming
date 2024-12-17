# NixOS Gaming Configuration

A NixOS configuration optimized for gaming with NVIDIA GPU support, Steam, and remote play capabilities through Sunshine.

## Features

### Gaming Support
- Steam with remote play and dedicated server support
- Sunshine for game streaming
- GameMode for optimized gaming performance
- MangoHud for in-game performance monitoring
- NVIDIA drivers (proprietary) with full composition pipeline

### Desktop Environment
- KDE Plasma 6
- SDDM display manager
- X11 server with NVIDIA support

### Audio
- PipeWire audio server with ALSA, PulseAudio, and JACK support
- 32-bit audio support for compatibility
- RTKit for real-time audio processing

### Remote Access
- Tailscale VPN integration
- SSH server
- XRDP for remote desktop access
- Sunshine for game streaming

### Development & Utilities
- VSCode
- Git, curl, wget, vim
- System monitoring tools (htop, btop)
- Firefox browser
- Flatpak support

## Prerequisites

- NVIDIA GPU (configuration is set up for NVIDIA drivers)
- NVMe drive (configured in GRUB bootloader)
- Network connection (managed by NetworkManager)

## Installation

1. Clone this configuration to your NixOS system
2. Copy the configuration files to `/etc/nixos/`
3. Run:
   ```bash
   sudo nixos-rebuild switch
   ```

## User Configuration

The system comes with a pre-configured user account:
- Username: `dev`
- Groups: networkmanager, wheel (sudo), audio, video, input
- Default shell: ZSH with Oh My Zsh
  - Theme: robbyrussell
  - Plugins: git, docker, sudo, kubectl

## Network Configuration

### Firewall Rules
The following ports are open:
- TCP: 22 (SSH), 47984, 47989, 47990, 48010, 3389 (RDP)
- UDP: Various ports for Tailscale and remote play services

### Remote Access Services
- SSH server enabled with password authentication
- Tailscale VPN
- XRDP for remote desktop
- Sunshine for game streaming

## Customization

### Adding Additional Packages
Edit the `environment.systemPackages` section in the configuration to add more packages:

```nix
environment.systemPackages = with pkgs; [
  # Add your packages here
];
```

### Modifying Gaming Settings
Steam and gaming-related settings can be adjusted in the `programs.steam` section.

## Version Information
- NixOS version: 24.05
- Linux kernel: 6.1
- KDE Plasma: 6.x

## Notes

- NVIDIA driver is configured to use the proprietary version
- Full composition pipeline is enabled for better performance
- Experimental features (flakes) are enabled for future use
- The configuration includes Australian locale and timezone settings
