{ pkgs, ... }:
{
  # nixvim:声明式 Neovim。插件由 Nix 构建进 derivation,可复现、完全可控,
  # 不再运行时 git 克隆。所有配置写在这里(原生 lua 用 extraConfigLua 追加)。
  programs.nixvim = {
    enable = true;
    nixpkgs.source = pkgs.path;   # 显式用当前(镜像) nixpkgs 构建;pkgs 在 home 模块可用,inputs 不可用
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    # 运行时依赖(lazy.nvim / telescope / 语言服务器等需要)
    extraPackages = with pkgs; [
      git
      ripgrep
      fd
      unzip
      # nodejs_22   # 部分语言服务器(node 系)运行时,按需取消注释
      # gcc         # 编译 treesitter 解析器/原生插件,按需取消注释
    ];

    # vim 基础选项(接近 LazyVim 默认体验)
    opts = {
      number = true;
      relativenumber = false;
      signcolumn = "yes";
      termguicolors = true;
      clipboard = "unnamedplus";
      tabstop = 2;
      shiftwidth = 2;
      expandtab = true;
      scrolloff = 8;
      wrap = false;
    };

    # 核心插件(声明式;全部由 Nix 构建)
    plugins = {
      lualine.enable = true;         # 状态栏
      gitsigns.enable = true;        # git 侧边标记
      which-key.enable = true;       # 按键提示
      neo-tree.enable = true;        # 文件树(对应 LazyVim 的 neo-tree)
      telescope = {
        enable = true;
        extensions = { fzf-native = { enable = true; }; };
      };
      treesitter = {
        enable = true;
        # 语法高亮解析器:用 pkgs.tree-sitter-grammars(全名 tree-sitter-*) 集合,包含 nix。
        # 旧路径 pkgs.tree-sitter.grammars.<短名> 在你这版 nixpkgs 里缺 nix,故改走这里。
        grammarPackages = with pkgs.tree-sitter-grammars; [
          tree-sitter-nix
          tree-sitter-python
          tree-sitter-lua
          tree-sitter-c
          tree-sitter-cpp
          tree-sitter-zig
        ];
      };
      lsp = {
        enable = true;
        # 语言服务器:按需增删(每个 = 一个 lspconfig server)
        servers = {
          clangd.enable = true;          # C / C++
          zls.enable = true;             # Zig
          nixd.enable = true;            # 示例:nix
          lua_ls.enable = true;          # 示例:lua
        };
      };
    };

    # 配色(对应 LazyVim 默认的 catppuccin)
    colorschemes.catppuccin.enable = true;
    colorscheme = "catppuccin";

    # 想写原生 lua 时放这里(等价于 ~/.config/nvim/lua/... )
    extraConfigLua = ''
      -- 在这里追加 LazyVim 风格的额外 lua 配置
    '';
  };
}
