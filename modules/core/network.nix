{ pkgs, host, ... }: 
{
  networking = {
    hostName = "${host}";
    networkmanager.enable = true;
    nameservers = [ ];
    firewall = {
      enable = true;
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];
    };
  };

  environment.systemPackages = with pkgs; [
    networkmanagerapplet
  ];
}
