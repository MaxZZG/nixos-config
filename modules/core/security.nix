{ ... }: 
{
  security.rtkit.enable = true; # for pipewire
  security.sudo.enable = true;
  security.pam.services.hyprlock = {};
}
