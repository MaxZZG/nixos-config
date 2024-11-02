{ pkgs, ... }:
{
  # C / C++ 开发环境(clang + gcc 双工具链)
  environment.systemPackages = with pkgs; [
    # 编译器
    gcc          # GNU C/C++：gcc、g++、(cc)
    clang        # LLVM C/C++：clang、clang++
    clang-tools  # clangd / clang-format / clang-tidy / clang-apply-replacements

    # 调试器
    gdb          # GNU 调试器
    lldb         # LLVM 调试器

    # 构建系统 / 工具链
    cmake        # CMake
    meson        # Meson
    ninja        # Ninja 构建后端
    gnumake      # make
    pkg-config   # 给编译器/链接器定位库与头文件(必须)
    binutils     # ld / objdump / nm / strip / addr2line
    autoconf     # autotools 系列
    automake
    libtool
    patch

    # 辅助工具
    ccache       # 编译缓存,加速重复构建
    valgrind     # 内存/性能检查

    # Zig 开发环境(自带 zig fmt / zig build,无需额外构建工具)
    zig          # Zig 编译器
    zls          # Zig 语言服务器(编辑器补全 / 跳转 / 诊断)
  ];
}
