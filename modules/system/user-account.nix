{ username, ... }:
{
  # 仅负责用户账号本身，与 home-manager 解耦
  users.users.${username} = {
    isNormalUser = true;
    description = "${username}";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };
  nix.settings.allowed-users = [ "${username}" ];
}
