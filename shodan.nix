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
      gnomeExtensions.dash-to-dock
      discord
      spotify
      syncthing
      obsidian
      steam
      minecraft
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
            install_url = "https://addons.mozilla.org/firefox/downloads/file/4237670/ublock_origin-1.56.0.xpi";
            installation_mode = "force_installed";
          };
          "jid1-q4sG8pYhq8KGHs@jetpack" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/file/4241438/adblock_for_youtube-0.4.6.xpi";
            installation_mode = "force_installed";
          };
          "MinYT@example.org" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/file/4225700/youtube_suite_search_fixer-7.0.xpi";
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
