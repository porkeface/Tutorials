### **Linux 根目录（/）下的核心目录**

| 目录名          | 用途                                                       | 重要文件/子目录示例           |
| :-------------- | :--------------------------------------------------------- | :---------------------------- |
| **/bin**        | **基础命令二进制文件**（所有用户可用）                     | `ls`, `cp`, `bash`            |
| **/boot**       | **系统启动文件**（内核、引导加载程序）                     | `vmlinuz-*`（内核）, `grub/`  |
| **/dev**        | **设备文件**（硬件或虚拟设备的接口）                       | `sda`（磁盘）, `tty`（终端）  |
| **/etc**        | **系统全局配置文件**                                       | `nginx/`, `ssh/`, `hosts`     |
| **/home**       | **普通用户的家目录**（每个用户一个子目录）                 | `/home/yourname/`             |
| **/lib**        | **系统库文件**（32位）                                     | `libc.so.*`（C 标准库）       |
| **/lib64**      | **64位系统库文件**                                         | 同 `lib`，但用于64位程序      |
| **/libx32**     | **x32 ABI 库文件**（较少用）                               |                               |
| **/lost+found** | **文件系统修复后的残留文件**（ext4 文件系统特有）          |                               |
| **/media**      | **可移动设备挂载点**（如 U 盘、光盘）                      |                               |
| **/mnt**        | **临时挂载目录**（手动挂载设备或分区）                     |                               |
| **/opt**        | **第三方软件安装目录**（可选应用）                         | `/opt/google/chrome/`         |
| **/proc**       | **虚拟文件系统**（内核和进程信息的实时接口）               | `/proc/cpuinfo`（CPU 信息）   |
| **/root**       | **超级管理员（root）的家目录**                             |                               |
| **/run**        | **运行时数据**（系统启动后生成的临时文件，如 PID 文件）    | `/run/sshd.pid`               |
| **/sbin**       | **系统管理命令二进制文件**（仅 root 可用）                 | `fdisk`, `iptables`           |
| **/snap**       | **Snap 包管理器的应用安装目录**（Ubuntu 特有）             |                               |
| **/srv**        | **服务数据目录**（存放网站、FTP 等服务的实际数据）         | `/srv/www/`（网站文件）       |
| **/sys**        | **虚拟文件系统**（暴露内核设备和驱动信息）                 | `/sys/class/net/`（网络接口） |
| **/tmp**        | **临时文件**（重启后可能清空）                             |                               |
| **/usr**        | **用户程序与只读数据**（二级目录结构，类似根目录）         | `/usr/bin/`, `/usr/lib/`      |
| **/var**        | **可变数据文件**（日志、缓存、数据库等）                   | `/var/log/`, `/var/www/html/` |
| **/www**        | **非标准目录**（通常用于存放网站文件，部分自定义环境使用） |                               |

------

### **关键说明**

1. **/etc、/bin、/lib 等**：
   - 是 Linux 系统的核心目录，**不要随意删除或修改**，否则可能导致系统崩溃。
2. **/home 和 /root**：
   - `/home` 存放普通用户的数据，`/root` 是管理员专属目录。
3. **/proc 和 /sys**：
   - 虚拟目录，**不占用磁盘空间**，实时反映系统状态（如 `cat /proc/meminfo` 查看内存）。
4. **非标准目录（如 /www）**：
   - 可能是用户自定义的，例如某些 Web 服务器默认将网站文件放在 `/var/www`，但部分环境会改用 `/www`。

---

以下是 Linux 根目录（`/`）下各核心目录的 **详细作用说明**，按功能分类整理，方便理解：

------

### **1. 系统核心运行目录**

| 目录       | 作用                                                | 典型内容示例                      | 是否可删除/修改 |
| :--------- | :-------------------------------------------------- | :-------------------------------- | :-------------- |
| **/bin**   | **基础命令**（所有用户可用）                        | `ls`, `cp`, `bash`                | ❌ 不可删        |
| **/sbin**  | **系统管理命令**（需 root 权限）                    | `fdisk`, `iptables`, `reboot`     | ❌ 不可删        |
| **/lib**   | **32位系统库文件**（支撑 `/bin` 和 `/sbin` 的命令） | `libc.so.*`（C 标准库）           | ❌ 不可删        |
| **/lib64** | **64位系统库文件**                                  | 同 `/lib`，适配64位程序           | ❌ 不可删        |
| **/proc**  | **虚拟文件系统**（实时内核/进程信息）               | `/proc/cpuinfo`, `/proc/meminfo`  | ⚠️ 只读          |
| **/sys**   | **虚拟文件系统**（内核设备/驱动配置）               | `/sys/class/net/eth0`（网卡配置） | ⚠️ 只读          |

------

### **2. 启动与设备管理**

| 目录      | 作用                                   | 典型内容示例                            |
| :-------- | :------------------------------------- | :-------------------------------------- |
| **/boot** | **启动文件**（内核、引导加载程序）     | `vmlinuz-*`, `grub/`                    |
| **/dev**  | **设备文件**（硬件/虚拟设备接口）      | `/dev/sda`（磁盘）, `/dev/tty1`（终端） |
| **/run**  | **运行时数据**（系统启动后的临时文件） | `/run/sshd.pid`（进程 PID）             |

------

### **3. 配置与用户数据**

| 目录      | 作用                                     | 典型内容示例                         |
| :-------- | :--------------------------------------- | :----------------------------------- |
| **/etc**  | **全局配置文件**（系统/服务配置）        | `nginx/`, `ssh/sshd_config`, `hosts` |
| **/home** | **普通用户家目录**（每个用户独立子目录） | `/home/ubuntu/`, `/home/yourname/`   |
| **/root** | **root 用户的家目录**（超级管理员专属）  | `/.bashrc`, `/install_scripts/`      |

------

### **4. 动态数据与临时文件**

| 目录     | 作用                                 | 典型内容示例                  |
| :------- | :----------------------------------- | :---------------------------- |
| **/var** | **可变数据**（日志、缓存、数据库等） | `/var/log/`, `/var/www/html/` |
| **/tmp** | **临时文件**（重启后可能清空）       | 临时下载文件、进程缓存        |

------

### **5. 软件与外部设备**

| 目录       | 作用                                       | 典型内容示例             |
| :--------- | :----------------------------------------- | :----------------------- |
| **/opt**   | **第三方软件安装目录**（可选应用）         | `/opt/google/chrome/`    |
| **/usr**   | **用户程序与只读数据**（类似二级根目录）   | `/usr/bin/`, `/usr/lib/` |
| **/media** | **可移动设备挂载点**（U 盘、光盘自动挂载） | `/media/usb-drive/`      |
| **/mnt**   | **手动挂载目录**（临时挂载硬盘/NFS）       | `/mnt/nas/`              |

------

### **6. 特殊目录**

| 目录            | 作用                                         | 备注                          |
| :-------------- | :------------------------------------------- | :---------------------------- |
| **/lost+found** | **文件系统修复后的残留文件**（ext4 特有）    | 通常为空                      |
| **/snap**       | **Snap 包管理器的应用目录**（Ubuntu 特有）   | `/snap/chromium/`             |
| **/srv**        | **服务数据目录**（网站/FTP 数据存放）        | 部分系统用 `/var/www/` 替代   |
| **/www**        | **非标准目录**（部分环境自定义的网站根目录） | 可能是 `/var/www/` 的符号链接 |

------

### **关键总结**

1. **系统必备目录**（勿删改）：
   `/bin`, `/sbin`, `/lib`, `/etc`, `/proc`, `/sys`
   - 删除会导致系统崩溃！
2. **用户数据目录**：
   - `/home` 存放用户文件，`/root` 是管理员专属。
   - `/var` 和 `/tmp` 存放动态数据，定期清理。
3. **扩展性目录**：
   - `/opt` 和 `/usr/local/` 适合安装第三方软件。
   - `/media` 和 `/mnt` 管理外接设备。
4. **虚拟目录**：
   - `/proc` 和 `/sys` 不占磁盘空间，直接映射内核状态。

------

### **操作建议**

- **修改配置** → 去 `/etc/`
- **安装软件** → 用 `/opt/` 或 `/usr/local/`
- **查看日志** → 进 `/var/log/`
- **挂载硬盘** → 选 `/mnt/` 或 `/media/`

### Linux**命令**

- 安装包

  ```bash
  sudo apt install <package> -y
  sudo：允许用户以管理员（超级用户，root）的权限执行命令
  -y：自动同意安装
  ```

- 访问本地公网地址

  ```bash
  curl ifconfig.me
  ```

- 端口设置

  检查所有监听端口：

  ```bash
  sudo netstat -tuln
  ```

  过滤特定端口：

  ```bash
  sudo netstat -tuln | grep <端口号>
  ```

  查看端口状态

  ```bash
  sudo ufw status
  ```

  添加端口·

  ```bash
  sudo ufw allow <端口号>
  ```

  删除端口

  ```bash
  sudo ufw delete allow <端口号>
  ```

- 查看域名

  ```bash
  nslookup <域名>
  ```

- ping网络

  ```bash
  ping <域名/ip>
  ```

  

### **添加Neo4j仓库并下载**

1. 添加 Neo4j 仓库

   添加 Neo4j 的 GPG 密钥和仓库：

   ```
   #最新版
   wget -O - https://debian.neo4j.com/neotechnology.gpg.key | sudo apt-key add -
   echo 'deb https://debian.neo4j.com stable latest' | sudo tee -a /etc/apt/sources.list.d/neo4j.list
   sudo apt update
   #指定版本
   wget -O - https://debian.neo4j.com/neotechnology.gpg.key | sudo apt-key add -
   echo 'deb https://debian.neo4j.com stable 4.4' | sudo tee /etc/apt/sources.list.d/neo4j.list
   sudo apt-get update
   ```

2. 安装 Neo4j

   安装 Neo4j 社区版（免费版）：

   ```
   sudo apt install neo4j -y
   ```

3. 启动并启用 Neo4j 服务

   ```
   sudo systemctl start neo4j
   sudo systemctl enable neo4j
   ```

4. 访问 Neo4j

   - 默认情况下，Neo4j 通过浏览器界面访问，地址为 http://localhost:7474。
   - 初次登录，用户名是 neo4j，需要设置新密码。
   - 如果从远程访问，需配置 neo4j.conf 文件（见下文）。

5. 配置远程访问（可选）

   编辑配置文件 `/etc/neo4j/neo4j.conf`

   - 找到 `dbms.default_listen_address=0.0.0.0`（取消注释并设置为 0.0.0.0 以监听所有接口）。

   - 保存并重启服务：

     ```
     neo4j restart
     ```

   - 配置防火墙允许 7474（HTTP）和 7687（Bolt）端口：

     ```
     sudo ufw allow 7474
     sudo ufw allow 7687
     ```

6. 测试连接

   使用浏览器访问 `http://<服务器IP>:7474` 或通过 Cypher Shell 交互：

   ```
   cypher-shell -u neo4j -p <你的密码>
   ```

**注意**：

- 确保服务器防火墙和网络允许外部访问对应端口。
- 生产环境建议限制访问 IP 并使用 SSL。

---



### **配置 Neo4j 并导入本地数据到云服务器上的 Neo4j** 

### 1. **配置 Neo4j**
- **编辑配置文件**:
  登录服务器后，打开 Neo4j 配置文件：
  
  ```bash
  sudo nano /etc/neo4j/neo4j.conf
  ```
  - 取消注释并设置以下行以允许远程访问：
    ```
    dbms.default_listen_address=0.0.0.0
    ```
  - 根据需要调整端口（默认 7474 和 7687）或其他设置（如内存分配）。
  - 保存（Ctrl+O, Enter, Ctrl+X）。
  
- **启动服务**:
  
  ```bash
  neo4j start
  ```
  检查状态：
  ```bash
   neo4j status
  ```

- **设置初始密码**:
  初次运行需要设置 `neo4j` 用户密码：
  ```bash
  neo4j-admin set-initial-password <your-password>
  ```

### 2. **准备本地 Neo4j 数据**
- **导出本地数据**:
  假设你的本地 Neo4j 数据在 `D:/Soft/neo4j/neo4j-community-4.4.9/data/databases/graph.db`（根据之前的讨论）。
  
  - 使用 `neo4j-admin` 导出：
    ```bash
    neo4j-admin dump --database=graph.db --to=/path/to/backup.dump
    ```
  - 或使用 Cypher 导出节点和关系到 `.cypher` 文件：
    ```bash
    :output file:///D:/Soft/neo4j/neo4j-community-4.4.9/import/output.cypher
    MATCH (n) RETURN n;
    MATCH ()-[r]->() RETURN r;
    :output
    ```

### 3. **导入数据到云服务器**
- **使用 Cypher Shell 导入** (适用于 `.cypher` 文件):

  停止 Neo4j 服务：

  ```bash
  neo4j stop
  ```

  确保文件在服务器上（如 `/home/user/output.cypher`）。

  ```bash
  cypher-shell -u neo4j -p <your-password> -f /home/user/output.cypher
  ```
  重启Neo4j服务

  ```bash
  neo4j restart
  ```

### 4. **验证导入**
- 登录 Neo4j 浏览器（`http://<服务器IP>:7474`）或运行查询：
  ```bash
  cypher-shell -u neo4j -p <your-password> "MATCH (n) RETURN count(n);"
  ```
- 确认节点和关系数量与本地一致。

### 5. **注意事项**
- **路径问题**: 确保服务器上的文件路径正确，Windows 路径需调整为 Linux 格式。
- **权限**: 确保 Neo4j 有权访问导入文件，必要时调整：
  ```bash
  sudo chown neo4j:neo4j /home/user/output.cypher
  ```
- **网络**: 打开防火墙端口（7474 和 7687）：
  ```bash
  sudo ufw allow 7474
  sudo ufw allow 7687
  ```

