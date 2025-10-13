# nmcli命令

##  设备管理

### 查看设备状态

```
# 查看所有网络设备状态
nmcli device status

# 简写形式
nmcli dev status
```



### 设备操作

```
# 启用/禁用设备
nmcli device connect wlp250     # 启用无线网卡
nmcli device disconnect wlp250  # 禁用无线网卡

# 重新扫描 WiFi
nmcli device wifi rescan

# 查看设备详情
nmcli device show wlp250
```



##  WiFi 管理

### 扫描和连接

```
# 扫描可用 WiFi
nmcli device wifi list

# 连接开放网络
nmcli device wifi connect "SSID名称"

# 连接加密网络
nmcli device wifi connect "SSID名称" password "密码"

# 连接到隐藏网络
nmcli device wifi connect "SSID名称" password "密码" hidden yes
```



## 连接配置管理

### 查看连接配置

```
# 查看所有保存的连接配置
nmcli connection show

# 查看特定连接的详细配置
nmcli connection show "连接名称"
```



### 创建和修改连接

```
# 创建新的有线连接
nmcli connection add type ethernet con-name "有线连接" ifname eth0

# 创建 WiFi 连接
nmcli connection add type wifi con-name "家庭WiFi" ifname wlp250 ssid "HomeWiFi" wifi-sec.psk "密码"

# 修改连接属性
nmcli connection modify "连接名称" ipv4.addresses "192.168.1.100/24"
nmcli connection modify "连接名称" ipv4.gateway "192.168.1.1"
nmcli connection modify "连接名称" ipv4.dns "8.8.8.8"
```



### 连接操作

```
# 启用连接
nmcli connection up "连接名称"

# 禁用连接
nmcli connection down "连接名称"

# 删除连接
nmcli connection delete "连接名称"

# 重新加载连接
nmcli connection reload
```



## 高级配置

### IP 地址设置

```
# 设置静态 IP
nmcli connection modify "连接名称" ipv4.method manual ipv4.addresses "192.168.1.100/24" ipv4.gateway "192.168.1.1" ipv4.dns "8.8.8.8"

# 设置 DHCP
nmcli connection modify "连接名称" ipv4.method auto

# 添加多个 DNS
nmcli connection modify "连接名称" ipv4.dns "8.8.8.8 8.8.4.4 1.1.1.1"
```



### 企业级 WiFi 配置（如校园网）

```
nmcli connection add type wifi con-name "企业网络" ifname wlp250 ssid "企业SSID" \
    wifi-sec.key-mgmt wpa-eap \
    802-1x.eap peap \
    802-1x.phase2-auth mschapv2 \
    802-1x.identity "用户名" \
    802-1x.password "密码"
```