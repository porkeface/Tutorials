# Cloudflare Tunnel 打通内网教程

> 适用场景：无公网 IP、校园网网关入站拦截、家庭宽带等无法直接端口映射的环境。  
> 优点：免费、自动 HTTPS、无需服务器中转、配置简单。

---

## 一、前置条件

1. 一个已注册且在 Cloudflare 上托管的域名（Nameserver 指向 Cloudflare）
2. 一台内网设备（Debian/Ubuntu/Windows 均可），已安装 Docker
3. Cloudflare 账号

---

## 二、在 Cloudflare 面板创建 Tunnel

### Step 1：进入 Zero Trust 面板

1. 登录 [Cloudflare Dashboard](https://dash.cloudflare.com)
2. 左侧菜单选择 **Zero Trust** > **Networks** > **Tunnels**
3. 点击 **Create a tunnel**

### Step 2：选择连接方式

选择 **Docker** 作为连接方式。

### Step 3：命名 Tunnel

给你的 Tunnel 取个名字，例如 `my-server`，点击 **Save tunnel**。

### Step 4：复制 Token

保存后会显示 Docker 运行命令，其中包含一个 `--token` 参数，例如：

```
--token eyJhIjoiNTBjMzE3OD...（一长串）
```

**记下这个 Token，后面要用。**

### Step 5：配置 Public Hostname（可选，可后续配置）

在 **Public Hostname** 部分，添加你要暴露的服务：

| 字段 | 值 |
|------|-----|
| Subdomain | 例如 `panel` |
| Domain | 你的域名（如 `example.com`） |
| Service | `http://localhost:20741`（替换为你的服务地址和端口） |
| Type | `HTTP` |

保存后，访问 `panel.example.com` 即可连通内网服务。

---

## 三、在内网设备上部署 cloudflared

### 方式 A：Docker Compose（推荐）

#### 1. 创建目录

```bash
mkdir -p /opt/1panel/docker/compose/cloudflared
```

#### 2. 编写 docker-compose.yml

```yaml
services:
  cloudflared:
    image: cloudflare/cloudflared:latest
    container_name: cloudflared
    restart: always
    network_mode: host
    command: tunnel --no-autoupdate run --token <替换为你的实际Token>
```

> **注意**：
> - `<替换为你的实际Token>` 换成第二步复制的 Token
> - `network_mode: host` 必须保留，否则容器无法访问宿主机上的服务
> - `--no-autoupdate` 防止频繁拉取新版本

#### 3. 启动

```bash
cd /opt/1panel/docker/compose/cloudflared
docker compose up -d
```

或者在 1Panel 面板中：**容器** > **编排** > 选择该文件路径 > 创建。

#### 4. 验证

```bash
docker logs cloudflared
```

看到类似 `Route propagate to...` 和 `Each proxy IP can resolve...` 表示连接成功。

---

### 方式 B：1Panel 编排界面（图形化）

1. 进入 1Panel > **容器** > **编排** > **创建编排**
2. 选择 **编辑** 模式
3. 粘贴上面的 YAML 内容
4. 将 `<替换为你的实际Token>` 换成实际 Token
5. **环境变量**留空，不需要额外配置
6. 点击创建并启动

---

### 方式 C：直接 Docker 运行（无 compose）

```bash
docker run -d \
  --name cloudflared \
  --restart always \
  --network host \
  cloudflare/cloudflared:latest tunnel \
  --no-autoupdate run --token <替换为你的实际Token>
```

---

## 四、后续管理

### 查看日志

```bash
docker logs -f cloudflared
```

### 停止/启动

```bash
docker stop cloudflared
docker start cloudflared
```

### 删除 Tunnel

```bash
docker rm -f cloudflared
```

然后在 Cloudflare 面板中删除对应的 Tunnel。

### 添加更多服务

在 Cloudflare Tunnel 配置页面，点击 **Public Hostname** > **Add a public hostname**，添加新的子域名和服务地址即可。

---

## 五、常见问题

### Q1：日志显示 "Connection refused"

`cloudflared` 容器无法访问目标服务。检查：
- 目标服务是否正在运行
- YAML 中 `network_mode: host` 是否保留
- 端口号是否正确

### Q2：访问域名显示 404 / 502

Tunnel 连接正常但后端服务无响应。检查：
- 服务地址和端口是否正确（如 `http://localhost:20741`）
- 服务本身是否只监听 IPv4（`0.0.0.0`）而非本地回环（`127.0.0.1`）

### Q3：校园网/公司网络可以用吗

可以。Cloudflare Tunnel 只需要**出站 HTTPS** 连接，绝大多数网络环境都允许。即使入站端口被封锁也能正常工作。

### Q4：速度怎么样

速度取决于 Cloudflare 节点到你服务器的路由，通常在管理面板、文档站、轻量 Web 服务等场景下完全够用。不适合大文件传输或视频流。

---

*最后更新：2026-04-05*
