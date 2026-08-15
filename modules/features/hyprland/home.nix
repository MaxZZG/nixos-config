{ pkgs, ... }:
{
  # hyprland 用户侧：实际窗口管理器配置
  wayland.windowManager.hyprland = {
    enable = true;
    systemd = {
      enable = true;
      variables = [ "--all" ];
    };
    # 具体配置可放在 extraConfig 或直接在此声明
    settings = {
      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "0xff89b4fa";
        "col.inactive_border" = "0xff45475a";
      };
      env = [
        "XCURSOR_SIZE,24"
      ];
    };
  };
}
