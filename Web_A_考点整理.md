- # Web A 考点整理

  ## 选择题（14×2）

  ## HTML与Web基础 

  1. HTML form标签使用：
     - action属性
     - method属性（用户提交表单的方式）
       - get、post两种请求方式
  
  2. tomcat的默认端口是什么

  3. javabean标签的使用

  4. jsp 获取客户端请求参数的内置对象
  
  5. jdbc里边用来执行简单不带参的SQL语句的接口
     - 带参数（PreparedStatement）
     - 不带参数（Statement）
  
  6. Servlet生命周期：
     - 初始化（init方法）
     - 处理请求（service方法）
     - 销毁（destroy方法）
  
  7. 作用域问题：
     - page、request、session、application
     - page、request、session、application各自用于共享数据的情况(哪个用于在多个用户之间共享数据)
     - page是给当前页面有效，request和session是一个用户一个，application是所有用户共用一个。
  
  8. web.xml配置（Web配置错误页面（使用范围）用什么标签）
     - 在这里面我们通常配置一些初始化参数，servlet过滤器、监听器，还有错误页面，那么我们如何在web.xml里面配置错误页面，使用哪个标签，就是说在web.xml里面用哪个标签来配置错误页面，比如说我们客户，我们用户从服务器的访问一个资源存在，那一般可以报错吧，然后我想把某一个页面，就把这一面更改成其他一面，那么这时候用哪个标签啊，这个大家要知道。
     - 错误页面：<error-page>
     - 初始化参数：<context-param>
  
  9. Servlet生命周期中：
     - Init、destroy方法执行一次
     - service方法执行多次

  10. jdbc常用的一些类及其用途
  
     **实际对应的JDBC核心接口及用途**

     1. **`Statement`**

        - **作用**：执行**静态SQL语句**（不带参数）

        - **典型用途**：
  
          ```
          Statement stmt = conn.createStatement();
          ResultSet rs = stmt.executeQuery("SELECT * FROM users");
          ```
  
     2. **`PreparedStatement`**（可能被误识别为"PastSendLay"）
  
        - **作用**：执行**带参数的SQL语句**（防SQL注入）
  
        - **典型用途**：
  
          ```
          PreparedStatement pstmt = conn.prepareStatement("INSERT INTO users VALUES(?,?)");
          pstmt.setInt(1, 101);
          pstmt.setString(2, "张三");
          pstmt.executeUpdate();
          ```
  
     3. **`CallableStatement`**
  
        - **作用**：调用数据库**存储过程**
  
        - **典型用途**：
  
          ```
          CallableStatement cstmt = conn.prepareCall("{call get_user_info(?)}");
          cstmt.setInt(1, 1001);
          cstmt.execute();
          ```

     4. **`ResultSet`**
  
        - **作用**：处理SQL查询返回的**结果集**
  
        - **典型用途**：
  
          ```
          while(rs.next()){
              System.out.println(rs.getString("username"));
          }
          ```

  ## 判断题（10×1）

  1. for each语句
  
  2. jsp标记
  
  3. **MVC架构对比**
  
     - **Model1**：JSP+JavaBean（高耦合）
     - **Model2**：MVC分层（推荐）
  
     - model和model2各自优缺点
  
  4. servlet过滤器中的doFilter()方法
  
  5. session中的invalidate()方法
  
  6. request中的getRemoteHost()方法
  
  ## 填空题（8×3）
  
  1. HTTP请求方法功能：
     - GET：获取服务器信息，作为响应返回
     - POST/PUSH：用于客户端向服务器提交数据
  2. 运行程序类型：
     - CS、BS
     - Client server、browser server
  3. **Ajax核心**
     - 对象：`XMLHttpRequest`
     - 特点：异步无刷新通信
  4. URL（统一资源定位器）定义
  5. 配置命令中language的默认值
  6. **使用cookie基本步骤**
     - 创建cookie对象
     - 传送cookie对象
     - 读取cookie对象
     - 设置对象有效时间
  7. JavaBean：
     - 定义与功能
     - 实现结果与分类使用（将原来页面程序片段封装到javabean当中能够实现业务逻辑层与视图层的分离）
  
  ## 简答题（3×6）
  
  1. JSP：
     - 定义
     - 执行过程
  2. Servlet生命周期：
     - 初始化
     - 处理请求
     - 服务结果等
  3. MVC：
     - 基本概念
     - 基本原理
     - 优缺点
  
  ## 编程题 (1×20)
  
  1. 实现简单网页计算器（需补充代码，只需要补充js部分）：
     - 使用application对象
