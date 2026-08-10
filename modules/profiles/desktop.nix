{
  inputs,
  username,
  host,
  ...
}:
{
  imports = [
    ../system/wayland.nix
    ../system/home-manager.nix
  ];

  # home-manager 引入（桌面环境通用）
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    users.${username} = {
      imports = [ ./../../modules/home ];
      home.username = "${username}";
      home.homeDirectory = "/home/${username}";
      home.stateVersion = "26.11";
      programs.home-manager.enable = true;
    };
  };
}
