

```bash
nixos-generate-config --dir ./hosts/laptop && rm ./hosts/laptop/configuration.nix

sudo nixos-rebuild switch --flake .#laptop --option substituters https://mirrors.ustc.edu.cn/nix-channels/store
```

其中，laptop 为主机名字，可以替换为 desktop。