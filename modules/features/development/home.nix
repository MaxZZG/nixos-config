{ config, lib, pkgs, ... }:
{
  # =============================================================
  # Visual Studio Code —— 用户级安装
  # =============================================================
  # home-manager 没有 vscode 专用模块,直接装包。
  # 官方版是 unfree 包,base.nix 已开 nixpkgs.config.allowUnfree。
  # 放这里(而非 nixos.nix)符合"能用 home 装就不走系统级"的约定。
  programs.vscode = {
    enable = true;
  };

  # =============================================================
  # CodeBuddy 插件(腾讯云代码助手)
  # =============================================================
  # 官方 Marketplace ID:Tencent-Cloud.coding-copilot
  # 该插件是闭源商业扩展,nixpkgs 的 vscode-extensions 不收录,
  # 故用 home-manager 激活钩子:换机/首次 rebuild 时装到 ~/.vscode/extensions。
  # 仅在扩展目录不存在时才调用 marketplace;已装时 rebuild 完全离线、无网络请求。
  home.activation.installCodeBuddy =
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if [ -z "$(find "${config.home.homeDirectory}/.vscode/extensions" -maxdepth 1 -type d -name 'tencent-cloud.coding-copilot-*' -print -quit 2>/dev/null)" ]; then
        $DRY_RUN_CMD ${pkgs.vscode}/bin/code --install-extension Tencent-Cloud.coding-copilot \
          || echo "CodeBuddy 安装失败(检查网络/marketplace),可手动运行: code --install-extension Tencent-Cloud.coding-copilot"
      fi
    '';
}
