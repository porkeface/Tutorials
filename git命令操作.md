<h1 style="text-align: center;"> 版本控制（GitHub + Typora）</h1>

- **推荐工具**：Git + GitHub/Gitee（国内）

------

### **1. 安装 Git**

- **作用**：Git 是一个分布式版本控制系统，用于跟踪文件变更（如代码、文档）。
- **下载地址**：https://git-scm.com/

------

### **2. 本地初始化 Git 仓库**

bash

```BASH
cd D:\Tutorials  # 进入你的本地文件夹
git init         # 初始化 Git 仓库（生成隐藏的 .git 文件夹）
git add .        # 将当前目录所有文件添加到暂存区（准备提交）
git commit -m "Initial tutorial commit"  # 提交更改到本地仓库，并附上说明
```

- **关键概念**：
  - `git init`：将普通文件夹变为 Git 管理的仓库。
  - `git add .`：标记文件的变更（新增/修改/删除）。
  - `git commit`：将变更永久记录到本地仓库。

------

### **3. 关联远程仓库（GitHub/Gitee）**

```BASH
git remote add origin <你的仓库地址>  # 将本地仓库与远程仓库关联
//例如以下例子
git remote add origin https://github.com/username/repository-name.git
git push -u origin main             # 推送本地提交到远程仓库
```

- **说明**：
  - `<你的仓库地址>`：如 GitHub 的 `https://github.com/用户名/仓库名.git`。
  - `git push`：将本地提交推送到远程服务器（默认分支名可能是 `main` 或 `master`）。
  - `-u origin main`：设置默认推送目标（下次可直接 `git push`）。

---

### **4. 查看当前远程仓库设置**

首先，检查当前设置的远程仓库 URL：

```bash
git remote -v
```

输出类似：

```bash
origin  https://github.com/porkeface/Tutorials.git (fetch)
origin  https://github.com/porkeface/Tutorials.git (push)
```

------

### 5. **修改远程仓库 URL**

如果你想修改远程仓库 URL，可以使用以下命令来更改它：

```bash
git remote set-url origin https://github.com/new-user/new-repo.git
```

将 `https://github.com/new-user/new-repo.git` 替换为你想要的正确 GitHub 仓库 URL。

---

**6.重新命名仓库分支**

使用 `git branch -m main` 将当前分支重命名为 `main`：

```bash
git branch -m main
```

- `git branch`：用于管理分支。
- `-m`：表示强制重命名，`-m 是 `--move --force` 的缩写。如果目标分支名已经存在，`-m` 会覆盖掉它。
- `main`：这是你想要的新分支名。

默认情况下，Git 的主分支通常命名为 `master`，但现在很多开源项目开始使用 `main` 作为默认分支名称。这个命令的目的是将本地仓库的默认分支从 `master` 重命名为 `main`。

---

### **7. 创建分支**

1. ```bash
   git branch 分支名称
   //git branch feature
   ```

2. 

### 切换分支

```bash
1.创建分支
git checkout ""
2.创建并切换分支
git checkout -b feature
```

### 推送分支到github

```
git push origin 分支名称
```

------

### **关键概念总结**

| 命令/操作               | 作用                                                     |
| :---------------------- | :------------------------------------------------------- |
| `git init`              | 初始化本地 Git 仓库。                                    |
| `git add .`             | 将文件变更添加到暂存区（准备提交）。                     |
| `git commit -m "消息"`  | 将暂存区的变更提交到本地仓库，需附上说明（如更新内容）。 |
| `git remote add origin` | 关联远程仓库（如 GitHub/Gitee）。                        |
| `git push`              | 将本地提交推送到远程仓库。                               |
| Typora 编辑 + Git 提交  | 用 Typora 修改文件后，通过 Git 提交变更，实现版本控制。  |

------

### 