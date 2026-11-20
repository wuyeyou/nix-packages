# nix-packages

个人维护的公开 Nix Flake 软件包集合，供自己日常使用。软件来自上游官方发布的二进制包，并完成 NixOS 适配。当前只支持 `x86_64-linux`，并自动跟随上游 Release 更新。

不同软件发布的安装包后缀，在依赖数量和维护成本上差别很大。为减少这些麻烦并保持较好的可维护性，各软件分别采用更合适的 Deb 或 AppImage，而不是统一成同一种格式。

## 可用软件

| 软件 | 上游 | Flake 输出 | 打包方式 |
| --- | --- | --- | --- |
| Cherry Studio | <https://github.com/CherryHQ/cherry-studio> | `cherry-studio` | AppImage |
| WordCraft | <https://github.com/storytold/wordcraft> | `wordcraft` | Deb |
| GridCraft | <https://github.com/storytold/gridcraft> | `gridcraft` | Deb |
| Lyrune | <https://github.com/amtoaer/lyrune> | `lyrune` | Deb |
| FreshGram | <https://github.com/Snowy-Fluffy/freshGram> | `freshgram` | AppImage |

## 安装与使用

把代码块的 `包名` 换成上一节表格中的 Flake 包名即可。

### 直接运行

```bash
nix run github:wuyeyou/nix-packages#包名
```

例如：

```bash
nix run github:wuyeyou/nix-packages#cherry-studio
```

### 安装到用户 Profile

```bash
nix profile install github:wuyeyou/nix-packages#包名
```

例如：

```bash
nix profile install github:wuyeyou/nix-packages#cherry-studio
```

### NixOS Flake 声明式安装

在系统 Flake 中加入输入，并用 `specialArgs` 把 `inputs` 传给 NixOS 模块：

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-packages = {
      url = "github:wuyeyou/nix-packages";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [ ./configuration.nix ];
    };
  };
}
```

在模块中安装：

```nix
{ pkgs, inputs, ... }:
{
  environment.systemPackages = [
    inputs.nix-packages.packages.${pkgs.stdenv.hostPlatform.system}.包名
  ];
}
```

例如，安装 Cherry Studio 时写成：

```nix
inputs.nix-packages.packages.${pkgs.stdenv.hostPlatform.system}.cherry-studio
```

`inputs.nixpkgs.follows` 让这些软件使用系统的 Nixpkgs。不设置 `follows` 时，软件使用本仓库 `flake.lock` 锁定的 Nixpkgs。

## 自动更新

GitHub Actions 每天北京时间 09:37 检查上游 GitHub Releases 中的常规版本（`x.y.z`），也可在 Actions 页面手动运行。它会更新版本和必要的哈希，构建成功后提交并推送。每款软件单独检查，一个软件失败不会阻止其他软件的检查。

这些提交只更新本仓库。把本仓库用作 Flake input 时，具体提交由使用者的 `flake.lock` 锁定；需要自行运行 `nix flake update nix-packages` 才会采用新版本。

## 维护

在仓库目录中更新全部软件，或只更新其中一款：

```bash
nix develop -c ./update
nix develop -c ./update cherry-studio
```

命令选择上游正式发布的常规版本，并更新版本与哈希；只有版本变化时才构建对应输出。它不会提交。失败时可能留下已修改的包定义，提交前检查 `git diff`。

构建但不安装：

```bash
nix build --no-link .#cherry-studio
```

新增软件时：

1. 添加 `packages/<名称>.nix`。Deb 包使用 `dpkg` 和 `autoPatchelfHook`，AppImage 使用 `appimageTools`。
2. 在 `packages.nix` 中增加同名输出。
3. 把名称加入 `./update` 和 `.github/scripts/update.sh`。
4. 在上面的软件表中增加一行。
