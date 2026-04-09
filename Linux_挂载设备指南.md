# Linux 挂载设备指南

在 Linux 系统中，"挂载"（Mount）意味着将物理存储设备（硬盘、USB、光盘等）的分区连接到文件系统中的某个目录，从而可以访问其内部文件。

---

## 1. 核心概念

- **挂载点 (Mount Point)**：必须是一个现有的空目录。挂载完成后，该目录将作为新设备的根。
- **设备标识**：
    - `/dev/sdX#`：如 `/dev/sdb1`（不推荐永久使用，可能随插入顺序改变）。
    - `UUID=<xxxx>`：全球唯一标识符（强烈推荐，最稳定）。

---

## 1.5 设备命名规则

Linux 对磁盘的命名格式为：`/dev/sdXN`

| 符号 | 含义 | 示例 |
|------|------|------|
| `sd` | 磁盘类型：SCSI / SATA / USB 统一用此命名 | — |
| `X`  | 第几个磁盘：`a` = 第 1 个，`b` = 第 2 个，依此类推 | `/dev/sda`，字母代表发现设备的先后顺序 |
| `N`  | 第几个分区：`1`, `2`, `3` … | `/dev/sdb1` = 第 2 块磁盘的第 1 个分区 |

例如：

```bash
root@debian:~# lsblk -f
NAME FSTYPE FSVER LABEL                    UUID                                 FSAVAIL FSUSE% MOUNTPOINTS
sda
├─sda1
│    vfat   FAT32                          0AB8-1FE7                             505.1M     1% /boot/efi
├─sda2
│    ext4   1.0                            a15eac77-9ad1-4b21-b2f0-07df2e34257e     44G    17% /
└─sda3
     swap   1                              11409d08-6d60-42ca-b39c-262b8c276c3a                [SWAP]
sdb
└─sdb1
     vfat   FAT32 \xb3±\xf2\xb1\xf2\xa4\xcePAN
                                           BEA6-BBCE                              47.6G    59% /mnt/usb
```



> **注意**：设备名可能因插入顺序、USB 接口变化而改变，因此**推荐用 UUID 挂载**。

---

## 2. 查看已连接设备

在插入 U 盘或硬盘后，运行以下命令确认设备名和文件系统格式：

```bash
# 推荐：清晰列出文件系统类型、LABEL 和 UUID
lsblk -f

# 备选：查看更详细的分区信息
sudo fdisk -l
```

---

## 3. 挂载步骤

### 3.1 创建挂载点
```bash
sudo mkdir -p /path/to/mountpoint
# 例如: sudo mkdir -p /mnt/usb
```

### 3.2 执行挂载 (临时)

推荐优先使用 UUID，避免拔插后设备名变动导致挂载错误。

```bash
# 格式: mount -t 类型 UUID=<值> 挂载点 -o 选项
mount -t vfat UUID=BEA6-BBCE /mnt/usb -o iocharset=utf8,codepage=936

# 或者直接用设备名（仅限本次会话）
# 格式: mount -t 类型 /dev/<设备名> 挂载点 -o 选项
mount -t ntfs-3g /dev/sdb1 /mnt/usb
```

- `-t` 可省略，系统会尝试自动检测。
- `-o` 是可选的，需要额外参数时加上。
- **设备名必须完整**：分区级为 `/dev/sdb1`，如果只写 `/dev/sdb`（整块磁盘）会报错。

**参数解释：**
- `-t vfat` / `-t ntfs-3g` / `-t ext4`：指定文件系统类型。
- `-o options`：挂载选项。
- **中文乱码修复**：对 Windows 格式的 U 盘 (FAT/vfat)，追加 `iocharset=utf8,codepage=936`。

  **选项详解：**
  - `codepage=936`：告诉内核，U 盘上的文件名是使用 **CP936（GBK）** 编码存储的（Windows 中文系统的默认编码）。
  - `iocharset=utf8`：告诉内核，将读取到的 GBK 文件名转换为 **UTF-8** 后再传给终端显示。

  如果不指定这两个参数，系统可能用 `iso8859-1` 解码中文文件名 → 全是乱码。

  另外也支持简写 `utf8` 选项（等同于 `iocharset=utf8`），但加上 `codepage=936` 能更稳妥地处理 Windows 创建的 FAT 分区中的中文名。

### 3.3 确认挂载
```bash
lsblk -f | grep 挂载目录
df -h
```

---

## 4. 解除挂载

确保没有程序正在使用该目录，然后运行：

```bash
# 如果提示 "target is busy":
# 1. cd 到别的目录
# 2. 检查是否有终端卡在里面

sudo umount /mnt/usb

# 如果强行无法卸载，可尝试延迟卸载:
sudo umount -l /mnt/usb
```

---

## 5. 开机自动挂载 (fstab)

编辑 `/etc/fstab` 可以让设备在重启后自动挂载或按需自动挂载。

### 5.1 方案 A：按需自动挂载（推荐 U 盘/移动硬盘）

插入 U 盘后无需手动 `mount`，**首次访问目录时自动挂载**，闲置后自动卸载：

1. 找到设备的 UUID：
   ```bash
   lsblk -f
   ```
2. 备份原文件：
   ```bash
   sudo cp /etc/fstab /etc/fstab.bak
   ```
3. 编辑配置：
   ```bash
   sudo nano /etc/fstab
   ```
4. 在末尾添加一行（以 FAT32 U 盘为例）：
   ```text
   UUID=BEA6-BBCE  /mnt/usb  vfat  x-systemd.automount,x-systemd.idle-timeout=60,nofail,iocharset=utf8,codepage=936,uid=0,gid=0,umask=022  0  0
   ```

   如果是 Debian 12 minimal 上的 NTFS 分区，优先直接写 `ntfs-3g`，兼容性更稳。比如：

   ```text
   UUID=13582E508A73F9FD  /mnt/sdc1  ntfs-3g  x-systemd.automount,x-systemd.idle-timeout=60,nofail,uid=1000,gid=1000,umask=022  0  0
   ```

5. 重载配置：
   ```bash
   sudo systemctl daemon-reload
   ```

6. 验证：
   ```bash
   # 插入 U 盘后直接访问（首次会延迟 ~1 秒）
   ls /mnt/usb
   ```

**选项说明：**
- `x-systemd.automount`：按需自动挂载（访问目录时触发）
- `x-systemd.idle-timeout=60`：60 秒无访问自动卸载
- `nofail`：设备不存在时不报错（不阻塞开机）
- `iocharset=utf8,codepage=936`：修复中文文件名乱码
- `uid=0,gid=0,umask=022`：设置挂载后的文件权限

**Debian 12 minimal 的 NTFS 注意事项：**
- 有些精简安装环境虽然是 Debian 12，但内核未提供 `ntfs3`，执行 `mount -t ntfs3 ...` 或在 `fstab` 里写 `ntfs3` 时可能报：`unknown filesystem type 'ntfs3'`
- 这种情况下直接安装 `ntfs-3g` 即可：
  ```bash
  sudo apt update
  sudo apt install ntfs-3g
  ```
- 普通用户的 UID/GID 不一定是 `1000`，可先用 `id` 查看后再写入 `fstab`

### 5.2 方案 B：开机永久挂载（适合固定硬盘）

如果是固定硬盘，不需要自动卸载，可以省去 automount 相关选项：

```text
UUID=a15eac77-...  /mnt/data  ext4  defaults,nofail 0  0
```

如果是 Debian 12 minimal 上的 NTFS 固定硬盘，可写成：

```text
UUID=13582E508A73F9FD  /mnt/sdc1  ntfs-3g  defaults,nofail,uid=1000,gid=1000,umask=022  0  0
```

修改后建议立刻测试，避免重启后因语法错误导致挂载失败：

```bash
sudo mount -a
 df -h
```

> **警告：** `/etc/fstab` 配置错误可能导致系统无法启动。务必先备份、仔细核对语法。

---

## 6. 常见问题排查

- **NTFS 无法挂载**：安装驱动 `sudo apt install ntfs-3g`。
- **exFAT 无法挂载**：安装驱动 `sudo apt install exfat-fuse exfatprogs`。


