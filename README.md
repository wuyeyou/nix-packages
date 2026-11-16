# 个人桌面软件包

这是与 NixOS 系统配置分离的本地 Flake，当前仅面向 `x86_64-linux`。独立构建使用本仓库 `flake.lock` 固定的 Nixpkgs；系统配置通过 Flake input 引用本仓库的 Git 提交，并让 Nixpkgs 跟随系统的 `desktop` input。

| 输出 | 来源与实现 |
| --- | --- |
| `cherry-studio` | 上游稳定版 AppImage，由 Nixpkgs 的 `appimageTools` 构建 |
| `wordcraft`、`gridcraft` | 复用 Nixpkgs 源码构建定义，覆盖上游稳定版与哈希 |
| `lyrune` | 上游稳定版 AppImage；使用 Nixpkgs 的 Wayland 客户端兼容本机 Mesa 驱动 |
| `freshgram` | 上游稳定版 AppImage，保留桌面入口、图标和 D-Bus 激活 |

```sh
nix build --no-link .#cherry-studio
```

检查并更新全部软件，或指定需要更新的软件：

```sh
nix develop -c ./update
nix develop -c ./update cherry-studio
```

该命令选择上游正式发布的常规版本，并更新源码和必要的依赖哈希。`packages.nix` 和 Flake 输出共用包定义；当前 `nix-update --flake` 与本机 Nix 的源码物化方式不兼容，因此更新时使用该入口。更新后检查实际启动行为、提交本仓库，再在系统仓库执行 `nix flake update personal-packages` 并构建系统。更新命令尚未配置定时执行。

本仓库目前只在本机，尚未发布到远端；系统配置引用 `/home/wuxuming/nix-packages`，在其他机器恢复时需要先提供该仓库。
