# FileBrowser 容器更改密码

当 `FileBrowser` 运行在 Docker 容器中时，修改密码最稳妥的方式不是直接在运行中的容器里改，而是：

1. 停掉原来的 `FileBrowser` 容器
2. 启一个临时容器去操作同一份数据库
3. 修改密码
4. 再启动原容器

这样可以避免数据库被占用导致 `timeout`。

---

## 1. 前提条件

先确认以下几点：

- 已经安装 Docker
- `FileBrowser` 容器名已知，例如 `filebrowser`
- 数据库文件已经通过卷挂载持久化
- 你可以在宿主机上执行 `docker` 命令

如果你不知道容器名，可以先看：

```bash
docker ps -a
```

---

## 2. 为什么不要直接在运行中的容器里改

`FileBrowser` 启动后会占用自己的数据库文件，例如：

```text
/database/filebrowser.db
```

如果你在同一个正在运行的容器里直接执行修改命令，可能会遇到：

- `timeout`
- 数据库锁定
- 命令执行失败

所以更推荐停掉原容器后，再用临时容器修改数据库。

---

## 3. 标准操作流程

### 3.1 停掉原容器

```bash
docker stop filebrowser
```

如果容器名不是 `filebrowser`，换成你自己的名字。

### 3.2 启一个临时容器修改密码

```bash
docker run --rm \
  --volumes-from filebrowser \
  filebrowser/filebrowser:latest \
  users update admin -p "YOUR_NEW_PASSWORD" -d /database/filebrowser.db
```

这条命令的作用：

- `docker run --rm`：启动一个临时容器，执行完自动删除
- `--volumes-from filebrowser`：复用原容器的卷挂载
- `filebrowser/filebrowser:latest`：使用 FileBrowser 镜像
- `users update admin`：修改 `admin` 用户
- `-p "YOUR_NEW_PASSWORD"`：设置新密码
- `-d /database/filebrowser.db`：指定数据库路径

### 3.3 启动原容器

```bash
docker start filebrowser
```

---

## 4. 常见命令说明

### 4.1 查看容器

```bash
docker ps -a
```

### 4.2 停止容器

```bash
docker stop filebrowser
```

### 4.3 启动容器

```bash
docker start filebrowser
```

### 4.4 删除临时容器

如果你用了 `--rm`，临时容器会在命令结束后自动删除，不需要手动清理。

---

## 5. 如果 `timeout` 还出现

如果你已经停掉原容器，仍然出现 `timeout`，通常检查这几项：

- 数据库路径是否正确
- 原容器是否真的已经停止
- 你是否在用正确的容器名
- 数据库目录是否已经正确挂载

可以先查看数据库文件是否存在：

```bash
docker run --rm \
  --volumes-from filebrowser \
  filebrowser/filebrowser:latest \
  sh -c "ls -l /database"
```

如果看不到 `filebrowser.db`，说明数据库路径可能不对。

---

## 6. 另一种写法

如果你不想用 `--volumes-from`，也可以直接显式挂载目录：

```bash
docker run --rm \
  -v /data:/srv \
  -v /path/to/database:/database \
  filebrowser/filebrowser:latest \
  users update admin -p "YOUR_NEW_PASSWORD" -d /database/filebrowser.db
```

这种写法更直观，但你需要自己确认实际挂载路径。

---

## 7. 小结

FileBrowser 容器改密码的核心思路是：

- 不要在运行中的主容器里直接改
- 先停容器
- 用临时容器操作同一份数据库
- 改完后再启动主容器

最常用的三条命令就是：

```bash
docker stop filebrowser
docker run --rm --volumes-from filebrowser filebrowser/filebrowser:latest users update admin -p "YOUR_NEW_PASSWORD" -d /database/filebrowser.db
docker start filebrowser
```

