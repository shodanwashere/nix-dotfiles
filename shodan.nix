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
    services = {
      syncthing = {
        enable = true;
        user = "shodan";
        dataDir = "/home/shodan";
        configDir = "/home/shodan/.config/syncthing";
        overrideDevices = true;
        settings = {
          devices = {
            "phantom" = { id = "${cfg.phantomID}"; };
          };
        };
      };
    };

    environment.systemPackages = with pkgs; [
      vim
      wget
      curl
      git
      gnome.gnome-tweaks
      gnome.gnome-terminal
      gnomeExtensions.dash-to-dock
      gnomeExtensions.just-perfection
      discord
      spotify
      syncthing
      obsidian
      steam
      minecraft
      neofetch
      flat-remix-icon-theme
      flat-remix-gtk
      flat-remix-gnome
      tree
      jdk11
    ];

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };

    programs.firefox = {
      enable = true;
      policies = {
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
        ExtensionSettings = {
          "uBlock0@raymondhill.net" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            installation_mode = "force_installed";
          };
          "jid1-q4sG8pYhq8KGHs@jetpack" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/adblock-for-youtube/latest.xpi";
            installation_mode = "force_installed";
          };
          "MinYT@example.org" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/youtube-suite-search-fixer/latest.xpi";
            installation_mode = "force_installed";
          };
          "sponsorBlocker@ajay.app" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi";
            installation_mode = "force_installed";
          };
        };
      };
    };

    nixpkgs.config.permittedInsecurePackages = [
      "electron-25.9.0"
    ];
  };
}
