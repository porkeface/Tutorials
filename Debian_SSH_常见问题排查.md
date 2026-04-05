# Debian 小主机 SSH 登录问题与解决指南

## 1. 本地权限报错 (Bad permissions / Bad owner)
**现象**:
```text
Bad permissions. Try removing permissions for user...
Bad owner or permissions on C:\\Users\\Hxxim/.ssh/config
```
**原因**:
SSH 出于安全考虑，要求密钥和配置文件必须有严格的权限设置。如果文件权限过于宽松（例如允许其他用户组读取），SSH 客户端会拒绝使用该文件，从而无法连接。

**解决办法**:
直接删除冲突的 `config` 文件。
```powershell
del C:\Users\Hxxim\.ssh\config
```

---

## 2. 主机指纹变更 (Host Identification Has Changed)
**现象**:
```text
@@@@ WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED! @@@@
...
Host key verification failed.
```
**原因**:
重装系统后，服务器生成的 SSH 密钥对发生了变化。你的电脑本地记录了旧的指纹（在 `known_hosts` 中），与新服务器的指纹不匹配，SSH 拦截了连接以防“中间人攻击”。

**解决办法**:
清除本地旧的指纹记录。
```powershell
ssh-keygen -R 192.168.50.156
```

---

## 3. Root 账号拒绝密码登录 (Permission denied for root)
**现象**:
用户名 `root` 和密码正确，但依然提示：
```text
Permission denied, please try again.
```
**原因**:
Debian 默认的安全策略禁止 Root 用户直接通过密码远程登录（配置文件默认 `PermitRootLogin prohibit-password`）。此外，如果安装时创建了普通用户，系统可能会跳过设置 Root 密码的步骤。

**解决办法**:
使用安装系统时创建的**普通用户账号**登录：
```powershell
ssh 你的用户名@192.168.50.156
```
如果需要更高权限，进入系统后使用 `su -` 命令切换。

---

## 4. 普通用户无法使用 sudo (Not in sudoers file)
**现象**:
登录普通用户 `jlee` 后，尝试提权安装软件：
```text
jlee 不是 sudoers 文件。此事将被报告。
```
**原因**:
Debian 默认安装下，普通用户没有管理员权限，且未加入 `sudo` 用户组。因此无法执行需要 Root 权限的命令。

**解决办法**:
不要使用 `sudo`，直接切换到 Root 用户身份：
```bash
su -
```
*(输入安装系统时设置的 **Root 密码**，提示符变为 `#` 即表示成功)*
