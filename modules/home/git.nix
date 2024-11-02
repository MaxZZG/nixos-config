{ pkgs, ... }: 
{
  programs.git = {
    enable = true;
    
    userName = "Max";
    userEmail = "zzgdar@163.com";

    extraConfig = {
      url = {
      "https://gh-proxy.icu/https://github.com/" = {
        insteadOf = "https://github.com/";
      };
    };
    };
  };
}