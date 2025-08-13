1. 使用Windows服务

   - 将Node.js应用注册为Windows服务，让它在后台运行。

   - 安装

     nssm

     （Non-Sucking Service Manager）工具：

     - 下载NSSM：https://nssm.cc/download

     - 解压后打开CMD（以管理员身份运行），导航到NSSM目录。

     - 注册服务：

       ```
nssm install MyNodeService
       ```

     - 在弹出的窗口中：

       - 路径：输入Node.js可执行文件路径（如C:\Program Files\nodejs\node.exe）。
       - 参数：输入你的脚本路径（如C:\code\uni-app-main\uni-app-main\server\node app.js）。
       - 服务名称：自定义（如MyNodeService）。

     - 点击“安装服务”。

   - 启动服务：
   
     ```
net start MyNodeService
     ```

   - 设置开机自启（可选）：在服务管理器中找到MyNodeService，右键属性，将启动类型设为“自动”。

2. 使用pm2管理Node.js进程

   - pm2是一个Node.js进程管理工具，适合在Windows上保持应用运行。

   - 安装Node.js和npm后，运行：

     ```
   npm install -g pm2
     ```

   - 启动应用：

     ```
   pm2 start C:\code\uni-app-main\uni-app-main\server\node app.js --name "NodeAPI"
     ```

   - 保存并设置开机自启：

     ```
     pm2 save
     pm2 startup
     ```
     
   - 跟随提示执行命令以启用开机启动。
   
   - 查看状态：
   
     ```
     pm2 list
     ```
   
3. 使用任务计划程序

   - 打开“任务计划程序”：
     - 按Win + R，输入taskschd.msc。
   - 创建任务：
     - 常规：命名（如NodeAPIService），勾选“无论用户是否登录都运行”。
     - 触发器：选择“开机时启动”。
     - 操作：新建，操作选择“启动程序”，程序填入C:\Program Files\nodejs\node.exe，参数填入脚本路径。
     - 设置：运行具有最高权限。
   - 保存并测试。

推荐方案：

- **首选pm2**：简单易用，适合Node.js开发，管理方便。
- **次选Windows服务**：更集成于系统，适合生产环境。