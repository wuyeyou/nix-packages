# 个人桌面软件包

这是与 NixOS 系统配置分离的公开 Flake，当前仅面向 `x86_64-linux`。独立构建使用本仓库 `flake.lock` 固定的 Nixpkgs；系统配置通过 Flake input 引用本仓库的 Git 提交，并让 Nixpkgs 跟随系统的 `desktop` input。

| 输出 | 来源与实现 |
| --- | --- |
| `cherry-studio` | 上游稳定版 AppImage，由 Nixpkgs 的 `appimageTools` 构建 |
| `wordcraft`、`gridcraft` | 上游稳定版 Deb 二进制，使用 Nixpkgs `autoPatchelfHook` 处理运行库 |
| `lyrune` | 上游稳定版 Deb 二进制，使用 Nixpkgs `autoPatchelfHook` 处理运行库 |
| `freshgram` | 上游稳定版 AppImage，保留桌面入口、图标和 D-Bus 激活 |

```sh
nix build --no-link .#cherry-studio
```

检查并更新全部软件，或指定需要更新的软件：

```sh
nix develop -c ./update
nix develop -c ./update cherry-studio
```

该命令选择上游正式发布的常规版本，并更新源码和必要的依赖哈希；只有版本变化时才构建对应 Flake 输出。`packages.nix` 和 Flake 输出共用包定义；当前 `nix-update --flake` 与本机 Nix 的源码物化方式不兼容，因此更新时使用该入口。命令会构建但不会提交；失败时可能留下已修改的包定义，应检查 `git diff` 并修复或撤回失败的更新。成功后检查实际启动行为、提交本仓库，再在系统仓库执行 `nix flake update personal-packages` 并构建系统。GitHub Actions 每天北京时间 09:37 逐包检查，也可在 Actions 页面手动运行；每个更新在独立工作树中构建成功后才单独提交并推送，某个失败不会阻止其他包检查。
