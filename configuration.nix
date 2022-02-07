{ config, pkgs, ... }:

{
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    cleanTmpDir = true;
  };

  networking = {
    hostName = "malmblade";
    networkmanager = {
      enable = true;
      dhcp = "dhclient";
    };
    useDHCP = false;
    interfaces = {
      enp2s0.useDHCP = true;
      wlp3s0.useDHCP = true;
    };
    firewall = {
      allowedTCPPorts = [ 631 ];
      allowedUDPPorts = [ 631 ];
    };
    nameservers = [ "8.8.8.8" ];
  };

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes ca-derivations

      keep-outputs = true
      keep-derivations = true
    '';

    gc = {
      automatic = true;
      dates = "weekly";
    };

    settings.trusted-users = [ "root" ];
  };
  nixpkgs.config.allowUnfree = true;

  time.timeZone = "America/New_York";
  location.provider = "geoclue2";
  services.localtime.enable = true;

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  sound.enable = true;
  hardware = {
    pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
      support32Bit = true;
    };

    bluetooth = {
      enable = true;
      package = pkgs.bluezFull;
    };

    opengl = {
      enable = true;
      driSupport32Bit = true;
      extraPackages32 = with pkgs.pkgsi686Linux; [
        libva
      ];
    };

    trackpoint.enable = true;
  };

  users = {
    mutableUsers = true;

    users.gwen = {
      isNormalUser = true;
      initialPassword = "setup";
      extraGroups = [ "wheel" ];
    };
  };

  environment.systemPackages = with pkgs; [
    bitwarden
    cargo
    curl
    direnv
    discord
    firefox
    gimp
    git
    inkscape
    jetbrains.clion
    jetbrains.idea-community
    mpv
    rustc
    rustfmt
    sshfs
    tmux
    vim
    wget
    xclip
    xdotool
  ];

  home-manager = {
    # use system nixpkgs instead of nixpkgs private to home-manager
    useGlobalPkgs = true;
    useUserPackages = true;

    users.gwen = {
      # all the configuration for your user goes in here! for example, you can
      # add things to home.packages here to add them to your user packages:
      # home.packages = with pkgs; [ ... ];

      programs.bash = {
        # enable bash, including allowing other things (like direnv) to hook into bash
        enable = true;
        # if you have a bashrc, your per-user bashrc config should go in the other options in here
        # the home-manager documentation has many examples, i can link if you want
      };

      programs.direnv = {
        # add direnv to PATH, and add hooks to any enabled shells
        enable = true;
        # enable nix plugin for direnv
        nix-direnv.enable = true;
      };
    };
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services = {
    openssh.enable = true;
    printing.enable = true;
  };

  services.xserver = {
    enable = true;
    displayManager.lightdm.enable = true;
    desktopManager.plasma5.enable = true;
    layout = "us";
    libinput = {
      enable = true;
      touchpad.naturalScrolling = true;
    };
  };

  fonts.fonts = with pkgs; [
    # fonts here!
  ];

  system.stateVersion = "22.05";
}
