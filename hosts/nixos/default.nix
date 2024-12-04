{ config, inputs, pkgs, ... }:

let user = "andreszb"; in
{
  imports = [
    ./disk-config.nix
    ../../modules/common
    ../../hardware-configuration.nix
    # inputs.hardware.nixosModules.asus-zephyrus-gu603h
  ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
      };
      efi.canTouchEfiVariables = true;
    };
  };

  # Set your time zone.
  time.timeZone = "America/Mexico_City";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking = {
    hostName = "zephy"; # Define your hostname.
    networkmanager.enable = true;
  };

  i18n.defaultLocale = "en_US.UTF-8";

  # Turn on flag for proprietary software
  nix = {
    nixPath = [ "/etc/nix/path" ];
    settings = {
      experimental-features = "nix-command flakes";
      allowed-users = [ "${user}" ];
      trusted-users = [ "@admin" "${user}" ];
      substituters = [ "https://nix-community.cachix.org" "https://cache.nixos.org" ];
      trusted-public-keys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];
    };
    optimise.automatic = true;
    package = pkgs.nix;
   };

  # Manages keys and such
  programs = {
    gnupg.agent.enable = true;

    # Needed for anything GTK related
    dconf.enable = true;

    # My shell
    zsh.enable = true;

    nix-ld.enable = true;
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
  };

  # Video support
  hardware = {
    graphics.enable = true;
    # pulseaudio.enable = true;
    # hardware.nvidia.modesetting.enable = true;
  };

  # It's me, it's you, it's everyone
  users.users = {
    ${user} = {
      isNormalUser = true;
      extraGroups = [
        "wheel" # Enable ‘sudo’ for the user.
      ];
    };
    root.shell = pkgs.bash;
  };

  environment.systemPackages = with pkgs; [
    git
    neovim
  ];

  system.stateVersion = "21.05"; # Don't change this

}
