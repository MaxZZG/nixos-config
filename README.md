

```bash
nixos-generate-config --dir ./hosts/hostname && rm ./hosts/hostname/configuration.nix

sudo nixos-rebuild switch --flake .#hostname --option substituters https://mirrors.ustc.edu.cn/nix-channels/store
```

其中，hostname 替换为 laptop 或者 desktop。