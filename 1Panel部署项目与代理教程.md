# 1Panel 部署 Web 项目与 Cloudflare Tunnel 代理教程

> 本教程介绍如何通过 1Panel 面板 + Cloudflare Tunnel 部署 Web 项目，适用于无公网 IP 的家庭服务器、NAS、校园网等环境。

---

## 一、前置条件

1. 一台已安装 1Panel 的机器（1Panel 支持 Linux 和 Windows）
2. 一个托管在 Cloudflare 的域名（Nameserver 指向 Cloudflare）
3. Cloudflare Tunnel 已部署且状态为"已连接"
4. 你的项目代码已准备就绪

---

## 二、上传项目文件

### 1. 规划目录
将项目放在 1Panel 管理路径下，方便统一维护：

```text
/opt/1panel/apps/项目名/          # Linux
C:\1panel\apps\项目名\            # Windows
```

### 2. 上传方式

| 文件数量 | 推荐方式 |
|----------|----------|
| 少量文件（几十以内） | 1Panel 文件管理 → 拖拽上传 |
| 大量文件（含依赖） | 本地打包为 `.zip` → 上传压缩包 → 服务器端解压 |

**为什么打包上传？**
1Panel 的 Web 上传对文件数量有限制（默认 1000 个）。包含 `node_modules`、`npm` 包等大量文件时，直接拖拽会失败。

### 3. 常用解压命令

SSH 终端中执行：

```bash
# .zip 格式
apt install -y unzip && unzip 你的文件.zip

# .tar.gz 格式
tar -xzf 你的文件.tar.gz
```

---

## 三、配置运行环境

1Panel 内置 **运行环境**（Runtime）功能，支持多种语言。

### 1. 添加环境
1. 1Panel 左侧菜单 → **运行环境** → 选择对应语言 → **添加**。
2. 填写配置：

| 配置项 | 说明 |
|--------|------|
| **名称** | 自定义，方便区分即可 |
| **源码目录** | 项目所在路径 |
| **启动命令** | 参考项目的 README，如 `node dist/api.js`、`python app.py` 等 |
| **应用端口** | 项目内部监听端口（如 3000、8000、5000），查看项目文档确认 |
| **外部映射端口** | 宿主机暴露端口，通常与应用端口相同即可 |
| **外部访问** | 开启后可通过 `服务器IP:端口` 直接访问 |

> **提示**：如果你的项目自带 `Dockerfile` 或 `docker-compose.yml`，也可以直接用 1Panel 的容器功能部署，不需要走运行环境。

### 2. 环境变量（按需配置）

**不是所有项目都需要环境变量。** 如果你的项目 README 或文档中提到了通过环境变量传递配置（如数据库密码、API Key、认证令牌等），才需要设置。

**方式 A：面板配置**
- 环境创建后 → 点击 **编辑容器**
- 找到 **环境变量** 区域添加键值对
- 保存后**重启**环境

**方式 B：.env 文件**
- 在项目根目录新建 `.env` 文件
- 格式：`KEY=VALUE`（每行一个）
- 部分框架会自动读取，部分需要额外安装 dotenv 包
- 修改后同样需要重启

### 3. 验证运行
浏览器访问 `http://服务器IP:端口`，确认页面正常加载后再进行下一步代理配置。

---

## 四、Cloudflare Tunnel 代理配置

### 1. 添加路由

1. 登录 [Cloudflare Dashboard](https://dash.cloudflare.com) → **Zero Trust** → **Networks** → **Tunnels**。
2. 点击隧道名称 → **已发布应用程序路由** → **添加已发布应用程序路由**。
3. 填写：

| 字段 | 填写建议 |
|------|----------|
| **Subdomain** | 子域名，如 `www`、`app`、`blog` |
| **Domain** | 在 Cloudflare 上托管的顶级域名 |
| **Path** | 通常留空。如需路径匹配再填正则表达式 |
| **Type** | `HTTP` （除非你的项目已自行配置 HTTPS） |
| **URL** | `localhost:项目端口` |

4. 保存即可。

### 2. 多个服务共用一条隧道

一条 Tunnel 可以代理多个服务，每个用不同的子域名区分：

| 子域名 | URL | 用途 |
|--------|-----|------|
| `www` | `localhost:3000` | 主站 |
| `api` | `localhost:8000` | 后端 API |
| `panel` | `localhost:20741` | 管理面板 |

### 3. 关于 HTTP 与 HTTPS

在 Tunnel 里配置 `HTTP`，外网访问时自动是 `https://`。

原因是 Cloudflare 在边缘节点自动完成 SSL 终结：
- 用户浏览器 → Cloudflare：HTTPS 加密
- Cloudflare → 你的服务器：HTTP（通过 Tunnel 加密通道传输）

你不需要在服务器上手动申请和配置证书。

---

## 五、两种代理方式的对比

| 方式 | 做法 | 适用场景 |
|------|------|----------|
| **直接走 Tunnel** | Tunnel URL 直连 `localhost:端口` | 个人项目、追求简洁 |
| **1Panel Nginx 反代** | Tunnel → Nginx(80) → 应用端口 | 需要 Nginx 缓存/压缩、需要 1Panel 备份功能、需要精细的请求头控制 |

---

## 六、注意事项

### 1. DNS 记录冲突
Tunnel 保存时如果提示 **"A/CNAME record already exists"**，说明 Cloudflare DNS 里已存在同名的 A 或 CNAME 记录。去 Cloudflare → DNS → 记录 中删除旧记录即可。Tunnel 会自动创建所需记录。

### 2. 中文文件名
Linux 服务器环境下，URL 中包含中文文件名可能导致 404。如果遇到问题，可先将文件名改为纯英文试试。

### 3. 根路径 `/` 返回 404
很多 Web 框架默认只将 `index.html` 作为首页入口。如果你的入口文件叫别的名字（如 `home.html`、`app.html`），访问根路径会报错。可参考你的项目文档确认入口文件名称。

### 4. 环境变量修改后不生效
环境变量在进程启动时读取一次。修改后需要**重启**对应的运行环境或容器，修改才会生效。

### 5. 端口被占用
如果运行时报端口冲突，先用 `ss -tlnp`（Linux）或 `netstat -ano`（Windows）检查哪个进程占用了该端口，再调整配置。

### 6. 部署前确认域名 NS 已切换
如果域名的 Nameserver 还在阿里云、腾讯云等注册商处，没有指向 Cloudflare，Tunnel 的 DNS 解析无法生效。请先在域名注册商处将 NS 修改为 Cloudflare 分配的两个地址。

### 7. 防火墙出站规则
Cloudflare Tunnel 需要访问 Cloudflare 的边缘节点。确保你的服务器的出站流量没有被防火墙拦截，尤其是 TCP 443 和 UDP 7844 端口。

---

*最后更新：2026-04-05*
