{ lib, config, pkgs, ... }:

let
  cfg = config.shodan;
in
{
  options.shodan = {
    enable = lib.mkEnableOption "enable shodan module";

    phantomID = lib.mkOption {
      description = ''
        ID of the Phantom Device
      '';
    };

    nvidia = lib.mkEnableOption "enable nvidia drivers";
  };

  config = lib.mkIf cfg.enable {
    # Configure Syncthing as a Service to run on startup
    services = {
      syncthing = {
        enable = true;                                 # Run on Startup
        user = "shodan";                               # Available to me and only me
        dataDir = "/home/shodan";
        configDir = "/home/shodan/.config/syncthing";
        overrideDevices = true;
        overrideFolders = true;
        settings = {
          devices = {
            "phantom" = { 
              id = "${cfg.phantomID}";
              autoAcceptFolders = true; 
            };  # Automatically add homeserver to configuration
          };
          folders = {
            "Default Folder" = {
              path = "/home/shodan/Sync";
              devices = ["phantom"];
            };
          };
        };
      };
    };

    environment.systemPackages = with pkgs; [
      vim                                 # TODO: add nvim when dotfile mastery gained
      wget
      curl
      git
      gnome.gnome-tweaks                  # do not use if gnome is not used
      gnome.gnome-terminal                # do not use if gnome is not used
      gnomeExtensions.dash-to-dock        # do not use if gnome is not used
      gnomeExtensions.just-perfection     # do not use if gnome is not used
      gnomeExtensions.appindicator        # do not use if gnome is not used
      discord
      betterdiscordctl
      spotify
      syncthing                           # do not use if synching is not needed
      obsidian
      kdenlive
      obs-studio
      audacity
      steam                               # do not use if you dont want games
      minecraft                           # do not use if you dont want games
      neofetch
      (pkgs.papirus-icon-theme.override { color = "green"; })
      tree
      etcher
      jdk11
      
    ];

    # Steam Settings
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };

    # Firefox Settings
    programs.firefox = {
      enable = true; # Install Firefox
      policies = {
        DisableTelemetry = true;      # Disable Telemetry for Firefox
        DisableFirefoxStudies = true; # Disable Studies (https://support.mozilla.org/en-US/kb/shield)
        EnableTrackingProtection = {  # Disable Tracking
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
        # Preinstall needed extensions
        ExtensionSettings = {
          # uBlock Origin
          "uBlock0@raymondhill.net" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            installation_mode = "force_installed";
          };
          # AdBlock for YouTube
          "jid1-q4sG8pYhq8KGHs@jetpack" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/adblock-for-youtube/latest.xpi";
            installation_mode = "force_installed";
          };
          # YouTube Search Fixer
          "MinYT@example.org" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/youtube-suite-search-fixer/latest.xpi";
            installation_mode = "force_installed";
          };
          # YouTube Sponsor Blocker
          "sponsorBlocker@ajay.app" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi";
            installation_mode = "force_installed";
          };
        };
      };
    };

    # Insecure Packages
    nixpkgs.config.permittedInsecurePackages = [
      # needed by Discord
      "electron-25.9.0"
      # needed by balenaEtcher
      "electron-19.1.9"
    ];

    virtualisation.docker.enable = true;
    users.users.shodan.extraGroups = [ "docker" ];

    hardware.opengl = lib.mkIf cfg.nvidia {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        amdvlk
        intel-media-driver      # LIBVA_DRIVER_NAME=iHD
        libvdpau-va-gl
        nvidia-vaapi-driver
        vaapiIntel                  # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
        vaapiVdpau
        vulkan-validation-layers
      ];
    };

    environment.variables.VDPAU_DRIVER = lib.mkIf cfg.nvidia "va_gl";
    environment.variables.LIBVA_DRIVER_NAME = lib.mkIf cfg.nvidia "nvidia";

    services.xserver.videoDrivers = lib.mkIf cfg.nvidia ["nvidia"];

    hardware.nvidia = lib.mkIf cfg.nvidia {
      modesetting.enable = true;
      powerManagement = {
        enable = false;
        finegrained = false;
      };
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.production;
    };
  };
}
