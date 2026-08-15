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
      # 主修饰键（Win 键）
      "$mainMod" = "SUPER";
      # 快捷键绑定
      bind = [
        # 用绝对路径，避免会话 PATH 里找不到 kitty 导致按了没反应
        "$mainMod, RETURN, exec, ${pkgs.kitty}/bin/kitty"   # Super+Enter 打开终端
        "$mainMod, Q, killactive"         # Super+Q 关闭当前窗口
      ];
    };
  };

  # 安装终端程序（kitty，原生支持 Wayland）
  home.packages = [ pkgs.kitty ];
}
