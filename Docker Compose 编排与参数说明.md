# Docker Compose 编排与参数说明

## 1. Compose 是什么

Docker Compose 用来用一个 `yaml` 文件描述多个容器服务，然后通过一条命令统一启动、停止和管理。

常见用途：

- 启动一个 Web 服务
- 同时启动数据库、缓存、后台服务
- 统一管理挂载目录、端口、环境变量
- 方便迁移和备份

最常见的命令：

```bash
docker compose up -d
docker compose down
docker compose logs -f
docker compose ps
```

## 2. 基本结构

一个最小的 Compose 文件通常长这样：

```yaml
services:
  app:
    image: nginx:latest
    container_name: app
    ports:
      - "8080:80"
```

结构含义：

- `services`：所有服务的集合
- `app`：服务名，名字可自定义
- `image`：使用的镜像
- `container_name`：容器名称
- `ports`：端口映射

## 3. 常用字段说明

### 3.1 `services`

`services` 是 Compose 的核心字段，用来定义多个容器服务。

示例：

```yaml
services:
  web:
    image: nginx:latest
  db:
    image: mysql:8.0
```

这里定义了两个服务：`web` 和 `db`。

### 3.2 `image`

指定镜像名称。`image` 的本质是告诉 Docker：去哪个仓库，拉哪个镜像，用哪个标签。

```yaml
image: filebrowser/filebrowser:latest
```

常见写法可以概括成：

```text
[registry/][namespace/]repository[:tag]
```

如果要更完整一点，还可以写成：

```text
[registry/][namespace/]repository[:tag][@digest]
```

各部分含义：

- `registry`：镜像仓库地址，通常可以省略
- `namespace`：命名空间，通常可以省略
- `repository`：镜像名，通常必须写
- `tag`：标签，通常可以省略
- `digest`：镜像摘要，少见，但能精确锁定镜像

含义：

- `filebrowser/filebrowser` 是镜像名
- `latest` 是标签

举例：

```yaml
image: nginx                          # repository
image: nginx:1.27                     # repository + tag
image: library/nginx:1.27             # namespace + repository + tag
image: docker.io/library/nginx:1.27   # registry + namespace + repository + tag
image: filebrowser/filebrowser:latest # namespace + repository + tag
```

省略规则：

- `tag` 可以省略，默认通常按 `latest` 理解
- `registry` 可以省略，默认使用 Docker 的默认镜像仓库
- `namespace` 有时可以省略，具体取决于镜像仓库的命名规则
- `digest` 一般可以省略，只有需要严格固定镜像内容时才使用

建议：

- 测试时可以用 `latest`
- 生产环境更稳妥的做法是固定版本号，避免镜像自动变化
- 如果你希望部署结果可重复，尽量不要长期依赖 `latest`

### 3.3 `container_name`

指定容器名称。

```yaml
container_name: filebrowser
```

作用：

- 容器会有一个固定名称
- 方便查看、停止、重启

注意：

- 如果你不写，Docker 会自动生成随机名字
- 一个名字只能给一个容器用，重复会报错

### 3.4 `restart`

控制容器退出后的重启策略。

常见值：

- `no`：默认，不自动重启
- `always`：总是重启
- `unless-stopped`：除非你手动停止，否则自动重启
- `on-failure`：只有异常退出才重启
- `on-failure:3`：异常退出最多重启 3 次

推荐：

```yaml
restart: unless-stopped
```

适合家用小主机和长期运行服务。

### 3.5 `ports`

端口映射，把宿主机端口转发到容器端口。

```yaml
ports:
  - "1080:80"
```

含义：

- 宿主机访问 `1080`
- 实际转到容器里的 `80`

访问方式：

- 浏览器访问 `http://宿主机IP:1080`

补充：

- 左边是宿主机端口
- 右边是容器端口
- 如果左边写 `80`，就表示宿主机直接占用 `80` 端口

### 3.6 `expose`

只声明容器内部会监听某个端口，不会开放给宿主机。

```yaml
expose:
  - "80"
```

特点：

- 不能直接通过宿主机浏览器访问
- 更适合容器之间通信
- 不会在宿主机上创建端口映射

### 3.7 `network_mode`

指定容器使用的网络模式。

常见值：

- `bridge`：默认桥接网络
- `host`：直接使用宿主机网络
- `none`：不联网

示例：

```yaml
network_mode: host
```

含义：

- 容器不再有独立网络隔离
- 容器监听什么端口，宿主机就直接占用什么端口
- 这时一般不需要再写 `ports`

建议：

- 普通服务优先用 `ports`
- `host` 适合少数特殊场景

### 3.8 `volumes`

挂载目录，把宿主机目录映射到容器内。

```yaml
volumes:
  - /data:/srv
  - ./database:/database
  - ./config:/config
```

含义：

- `/data` 是宿主机目录
- `/srv` 是容器内目录

用途：

- 保存数据
- 保留配置
- 容器重建后数据不丢失

建议：

- 需要长期保存的数据一定要挂载出去
- 不要把重要数据只放在容器内部

### 3.9 `environment`

设置环境变量。

```yaml
environment:
  - TZ=Asia/Shanghai
  - PUID=1000
  - PGID=1000
```

用途：

- 设置时区
- 设置程序运行参数
- 控制权限和初始化行为

### 3.10 `command`

覆盖镜像默认启动命令。

```yaml
command: ["--port", "8080"]
```

适合：

- 镜像默认参数不符合需求时
- 需要额外启动参数时

### 3.11 `depends_on`

定义服务启动顺序。

```yaml
depends_on:
  - db
```

含义：

- `app` 会在 `db` 之后启动
- 但不代表 `db` 一定已经完全可用

注意：

- 它只控制启动顺序，不负责健康检查
- 如果要保证服务真正可用，最好再配合健康检查

### 3.12 `working_dir`

指定容器内的工作目录。

```yaml
working_dir: /app
```

### 3.13 `env_file`

从外部文件读取环境变量。

```yaml
env_file:
  - .env
```

适合：

- 把敏感配置和 Compose 文件分开
- 让配置更清晰

## 4. 常见组合示例

### 4.1 单服务 Web

```yaml
services:
  nginx:
    image: nginx:latest
    container_name: nginx
    restart: unless-stopped
    ports:
      - "8080:80"
```

### 4.2 FileBrowser 示例

```yaml
services:
  filebrowser:
    image: filebrowser/filebrowser:latest
    container_name: filebrowser
    restart: unless-stopped
    ports:
      - "1080:80"
    volumes:
      - /data:/srv
      - ./database:/database
      - ./config:/config
```

说明：

- `/data`：你要浏览的真实文件目录
- `/srv`：FileBrowser 容器内默认管理目录
- `./database`：保存数据库
- `./config`：保存配置

### 4.3 带数据库的服务

```yaml
services:
  db:
    image: mysql:8.0
    container_name: mysql
    restart: unless-stopped
    environment:
      - MYSQL_ROOT_PASSWORD=123456
    volumes:
      - ./mysql:/var/lib/mysql

  app:
    image: myapp:latest
    container_name: myapp
    restart: unless-stopped
    depends_on:
      - db
    ports:
      - "8080:8080"
```

## 5. `ports`、`expose`、`host` 的区别

### 5.1 `ports`

```yaml
ports:
  - "1080:80"
```

- 对外开放端口
- 宿主机通过映射端口访问容器
- 最常用

### 5.2 `expose`

```yaml
expose:
  - "80"
```

- 只给容器之间使用
- 不会自动暴露到宿主机
- 宿主机浏览器不能直接访问

### 5.3 `host`

```yaml
network_mode: host
```

- 容器和宿主机共用网络
- 不需要端口映射
- 容器监听端口会直接占用宿主机端口

### 5.4 选择建议

- 普通 Web 服务：优先用 `ports`
- 容器之间内部通信：考虑 `expose`
- 特殊网络需求：再考虑 `host`

## 6. 目录挂载建议

常见的宿主机目录习惯：

- `/home/用户名/`：个人文件
- `/var/lib/服务名/`：服务持久数据
- `/etc/服务名/`：配置文件
- `/var/log/服务名/`：日志
- `/opt/服务名/`：第三方软件或独立部署目录
- `/data/` 或 `/srv/`：自己专门规划的数据目录

如果是自己搭建服务，通常建议：

- 数据放 `/var/lib/服务名/` 或 `/data/服务名/`
- 配置单独放一个目录
- 日志单独保留，便于排查问题

## 7. 书写 Compose 时的检查清单

- 服务名是否拼写正确
- `image` 是否可拉取
- `ports`、`volumes`、`environment` 字段是否拼写正确
- 缩进是否统一
- 需要持久化的数据是否已经挂载
- 端口是否和别的服务冲突
- 是否真的需要 `host` 模式

## 8. 常用命令

```bash
docker compose up -d
docker compose down
docker compose restart
docker compose logs -f
docker compose ps
docker compose pull
docker compose config
```

说明：

- `up -d`：后台启动
- `down`：停止并删除容器
- `restart`：重启服务
- `logs -f`：实时查看日志
- `ps`：查看当前状态
- `pull`：拉取最新镜像
- `config`：检查 Compose 配置是否正确

## 9. 常见错误

### 9.1 字段拼写错误

比如：

- `volums` 应写成 `volumes`
- `posts` 应写成 `ports`
- `comtainer_name` 应写成 `container_name`
- `unless-stop` 应写成 `unless-stopped`

这类错误会直接导致 YAML 校验失败。

### 9.2 `ports` 和 `host` 混用

如果使用：

```yaml
network_mode: host
```

通常就不要再写 `ports` 了。

### 9.3 数据没挂载

如果重要数据只写在容器内部：

- 容器删除后数据会丢
- 升级重建也容易丢配置

### 9.4 目录权限不对

挂载目录后如果容器无法读写，通常是权限问题。

解决思路：

- 检查宿主机目录权限
- 检查容器运行用户
- 检查挂载路径是否正确

## 10. 总结

Compose 的核心思路很简单：

- 用 `services` 定义服务
- 用 `image` 指定镜像
- 用 `ports` 暴露端口
- 用 `volumes` 持久化数据
- 用 `environment` 传递参数
- 用 `restart` 提高稳定性

如果你是自己在小主机上部署服务，优先记住这几个字段：

- `image`
- `container_name`
- `restart`
- `ports`
- `volumes`
- `environment`
- `network_mode`

其中最常用的组合就是：

```yaml
services:
  app:
    image: xxx:latest
    container_name: app
    restart: unless-stopped
    ports:
      - "8080:80"
    volumes:
      - ./data:/data
```
