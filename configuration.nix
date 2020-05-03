{ config, pkgs, lib, ... }: 

{

  imports =
  [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/sda";
  };

  networking = {
    hostName = "cloudcraft"; 
    interfaces.ens3.ipv4.addresses = [{ 
      address = (builtins.getEnv "floating_ip"); 
      prefixLength = 32;
    }];
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  users.users.root = {
    openssh.authorizedKeys.keys = lib.splitString "\\n" (builtins.getEnv "authkeys") ++ [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDOm2JiPs6geaZ+coOju+kpUIbaJkLOnydTGcPc+K4V5ksqkqDW2i2fPjZdV3U8Eihv+wUmyYkj5SU+Q75JYy1/0oKwWQi2SX9EqrSsK/JOryex8FmqwhKwm7+afrryILCOJyhhNGeKOm04stxY50UDSrCmOSpyX15PZnMPB6BRuWdiWi3jvGwja2+lFwtKlIJuYooBFCAE7R7buqHgduhvtoLWTh8sLRiKDo9vP7s63qyXmvCx7tY06lSD3V65rRBd6SjA8mqHQZN9RL0RgJry65HVMIE2BapniLeUJi2L32hvttstvkj2PMA0Obm+bxlimKSSXZkTRPoxC/p3tWy7 ixxie@meso"
    ];
  };
  
  nixpkgs.config.allowUnfree = true;

  services.minecraft-server = {
    enable = true;
    eula = true;
    declarative = true;
    openFirewall = true;
    serverProperties = {
      server-port = 43000;
      difficulty = 2;
      gamemode = 1;
      max-players = 23;
      motd = "welcome to cloudcraft!";
      white-list = true;
      enable-rcon = true;
      "rcon.password" = (builtins.getEnv "rconpass");
    };
    whitelist = {
      IxxiePixxie = "7c473f5c-21de-494d-8165-a8f6b8f6c9fa"; 
      Palainator = "d7b4c09a-962b-4b84-98f8-883cd4c49de9";
      Juliawilldoyou = "bc612d07-1731-4cf1-80c1-0aa09dd6e60e";
      Anmatika = "a2bdb068-62ed-4169-9ad5-8df72b314abc";
    };
  };

}
