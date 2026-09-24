# nixos-config

per-host 架构：`hosts/<主机名>/` 一个目录 = 一台机器，目录名即主机名。
flake 会自动发现 `hosts/` 下的目录（以 `_` 开头的不参与构建）。

## 目录结构

```
flake.nix                      # 自动发现 hosts/*，生成 nixosConfigurations
hosts/
  <主机名>/
    default.nix                # 本机专属：硬件 + 选一个 host-type + 内核参数/显卡等
    hardware-configuration.nix # 本机生成（磁盘/UUID 等）
modules/
  host-types/                  # 机型共享：laptop / desktop / minipc / convertible
  system/                      # 基础系统 + 用户/home-manager + 自动发现 features/*
  home/                        # 用户侧聚合
  features/                    # 各功能（自动发现 nixos.nix / home.nix）
```

## 新增一台机器

1. 在目标机器上生成硬件配置：

   ```bash
   sudo nixos-generate-config --show-hardware-config > hosts/<主机名>/hardware-configuration.nix
   ```

2. 复制一个已有 host 目录，改 `default.nix` 里的 host-type 指向（laptop/desktop/minipc/convertible）。

3. `git add hosts/<主机名>`（flake 只识别 git 跟踪的文件），然后构建：

   ```bash
   sudo nixos-rebuild switch --flake .#<主机名>
   ```

## 构建当前机器

```bash
sudo nixos-rebuild switch --flake .#<主机名> \
  --option substituters https://mirrors.ustc.edu.cn/nix-channels/store
```

## 划分原则

- **per-host**：`fileSystems`、`boot.loader`、内核参数、显卡驱动、niri 的 `output`/缩放等。
- **共享 `modules/`**：桌面环境、键绑、软件包、用户、网络、音频等与硬件无关的内容。
