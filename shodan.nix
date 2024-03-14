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
        settings = {
          devices = {
            "phantom" = { id = "${cfg.phantomID}"; };  # Automatically add homeserver to configuration
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
      discord
      spotify
      syncthing                           # do not use if synching is not needed
      obsidian
      steam                               # do not use if you dont want games
      minecraft                           # do not use if you dont want games
      neofetch
      flat-remix-icon-theme               # do not use if you dont need this
      flat-remix-gtk                      # do not use if you dont need this
      flat-remix-gnome                    # do not use if you dont need this
      tree
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
          }
        };
      };
    };

    # Insecure Packages
    nixpkgs.config.permittedInsecurePackages = [
      # Needed by Discord?
      "electron-25.9.0"
    ];
  };
}
