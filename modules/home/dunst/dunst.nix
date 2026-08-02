{ pkgs, ... }:
{
  services.dunst = {
    enable = true;
    settings = {
      global = {
        monitor = 0;
        follow = "mouse";
        width = 300;
        height = 100;
        origin = "top-right";
        offset = "10x50";
        scale = 0;
        notification_limit = 5;
        progress_bar = true;
        progress_bar_height = 3;
        progress_bar_frame_width = 1;
        progress_bar_min_width = 100;
        progress_bar_max_width = 280;
        indicate_hidden = "yes";
        transparency = 0;
        separator_height = 2;
        padding = 12;
        horizontal_padding = 12;
        text_icon_padding = 0;
        frame_width = 1;
        frame_color = "#89b4fa";
        separator_color = "frame";
        sort = "yes";
        idle_threshold = 120;
        font = "RecMonoCasual Nerd Font Mono 11";
        line_height = 0;
        markup = "full";
        format = "<b>%s</b>\\n%b";
        alignment = "left";
        vertical_alignment = "center";
        show_age_threshold = 60;
        ellipsize = "middle";
        ignore_newline = "no";
        stack_duplicates = true;
        hide_duplicate_count = false;
        show_indicators = "yes";
        icon_position = "left";
        min_icon_size = 0;
        max_icon_size = 32;
        sticky_history = "yes";
        history_length = 20;
        browser = "firefox";
        always_run_script = true;
        title = "Dunst";
        class = "Dunst";
        corner_radius = 8;
      };

      urgency_low = {
        background = "#1e1e2e";
        foreground = "#cdd6f4";
        timeout = 4;
      };

      urgency_normal = {
        background = "#1e1e2e";
        foreground = "#cdd6f4";
        timeout = 6;
      };

      urgency_critical = {
        background = "#1e1e2e";
        foreground = "#f38ba8";
        frame_color = "#f38ba8";
        timeout = 0;
      };
    };
  };
}
