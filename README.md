# Shodan's Nix Dotflies
Dotfiles for use in NixOS, written by yours truly. :)
> For more information about NixOS, consult [here](https://nixos.org).

## Usage

```bash
$ git clone git@github.com:shodanwashere/nix-dotfiles.git ~/nix
```

Go to your `configuration.nix` file and perform the following changes:

```nix
  ...
  imports = [
    ./hardware-configuration.nix
++  /home/yourusername/nix/shodan.nix
  ];

++shodan.enable = true;
++shodan.phantomID = "..."; # modify the file and erase this line if you're not using syncthing.
...
```

You can use the provided `rebuild` script to do this.

## Credits

Thanks to [No Boilerplate](https://www.youtube.com/@NoBoilerplate) for introducing me to NixOS and for the incredible `rebuild` script.
Some of my setup was also achieved by following guides written, recorded and published by [Vimjoyer](https://www.youtube.com/@vimjoyer) on YouTube.
