{ pkgs, ... }:
{
  environment.systemPackages = [
    (pkgs.appimageTools.wrapType2 {
      name = "wechat";
      src = pkgs.fetchurl {
        url = "https://dldir1v6.qq.com/weixin/Universal/Linux/WeChatLinux_x86_64.AppImage";
        sha256 = "sha256:4f54ad2902ecd6f6fdc5680b73547f80d5423bf470b01237a579a2e5b3caeeeb";
      };
    })
  ];
}
