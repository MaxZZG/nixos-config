{ pkgs, ... }:
{
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;

        modules-left = [
          "hyprland/workspaces"
        ];
        modules-center = [
          "clock"
        ];
        modules-right = [
          "tray"
          "pulseaudio"
          "network"
          "cpu"
          "memory"
          "battery"
        ];

        "hyprland/workspaces" = {
          all-outputs = true;
          disable-scroll = true;
        };

        "clock" = {
          interval = 1;
          format = "{:%Y-%m-%d  %H:%M:%S}";
          format-alt = "{:%a, %b %d  %H:%M}";
        };

        "cpu" = {
          interval = 2;
          format = " {usage}%";
        };

        "memory" = {
          interval = 2;
          format = " {used:0.1f}G";
        };

        "network" = {
          format-wifi = " {signalStrength}%";
          format-ethernet = " {ipaddr}";
          format-disconnected = " Disconnected";
          tooltip-format = "{ifname}: {ipaddr}";
        };

        "pulseaudio" = {
          format = "{icon} {volume}%";
          format-muted = " Muted";
          format-icons = {
            default = [ " " " " " " ];
          };
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          on-scroll-up = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
          on-scroll-down = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
        };

        "battery" = {
          interval = 10;
          format = "{icon} {capacity}%";
          format-icons = [ " " " " " " " " " " " " " " ];
          format-charging = " {capacity}%";
        };

        "tray" = {
          spacing = 8;
        };
      };
    };

    style = builtins.readFile ./style.css;
  };
}
