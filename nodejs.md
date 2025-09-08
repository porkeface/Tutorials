### fs模块

#### **(1) 读取文件**

- fs.readFile(path[, options], callback)

  （异步）

  - 读取文件内容。

  - 参数：

    - path：文件路径。
    - options：可选，指定编码（如 'utf8'）或标志。
    - callback(err, data)：回调函数，err 为错误对象，data 为文件内容。

  - 示例：

    javascript

    ```
    fs.readFile('example.txt', 'utf8', (err, data) => {
      if (err) throw err;
      console.log(data);
    });
    ```

- fs.readFileSync(path[, options])

  （同步）

  - 返回文件内容，直接阻塞。

  - 示例：

    javascript

    ```
    let data = fs.readFileSync('example.txt', 'utf8');
    console.log(data);
    ```

#### **(2) 写入文件**

- fs.writeFile(path, data[, options], callback)

  （异步）

  - 写入或覆盖文件内容。

  - 参数：

    - path：文件路径。
    - data：要写入的内容。
    - options：可选，指定编码或标志（如 { flag: 'a' } 为追加）。
    - callback(err)：回调函数。

  - 示例：

    javascript

    ```
    fs.writeFile('example.txt', 'Hello, Node.js!', 'utf8', (err) => {
      if (err) throw err;
      console.log('文件已写入');
    });
    ```

- fs.writeFileSync(path, data[, options])

  （同步）

  - 示例：

    javascript

    ```
    fs.writeFileSync('example.txt', 'Hello, Sync!');
    ```

#### **(3) 追加内容**

- fs.appendFile(path, data[, options], callback)

  （异步）

  - 向文件末尾追加内容。

  - 示例：

    javascript

    ```
    fs.appendFile('example.txt', '\nNew line', 'utf8', (err) => {
      if (err) throw err;
      console.log('追加成功');
    });
    ```

- **fs.appendFileSync(path, data[, options])**（同步）

#### **(4) 删除文件**

- fs.unlink(path, callback)

  （异步）

  - 删除文件。

  - 示例：

    javascript

    ```
    fs.unlink('example.txt', (err) => {
      if (err) throw err;
      console.log('文件删除成功');
    });
    ```

- **fs.unlinkSync(path)**（同步）

#### **(5) 目录操作**

- fs.mkdir(path[, options], callback)

  （异步）

  - 创建目录。

  - 示例：

    javascript

    ```
    fs.mkdir('newFolder', { recursive: true }, (err) => {
      if (err) throw err;
      console.log('目录创建成功');
    });
    ```

- fs.rmdir(path[, options], callback)

  （异步）

  - 删除目录（空目录）。

- fs.readdir(path[, options], callback)

  （异步）

  - 读取目录内容，返回文件和子目录数组。

  - 示例：

    javascript

    ```
    fs.readdir('.', (err, files) => {
      if (err) throw err;
      console.log(files); // 列出当前目录文件
    });
    ```

#### **(6) 检查文件/目录**

- fs.existsSync(path)

  （同步）

  - 检查文件或目录是否存在，返回 true 或 false。

  - 示例：

    javascript

    ```
    console.log(fs.existsSync('example.txt')); // true 或 false
    ```

- fs.stat(path, callback)

  （异步）

  - 获取文件或目录的元信息（如大小、修改时间）。

  - 示例：

    javascript

    ```
    fs.stat('example.txt', (err, stats) => {
      if (err) throw err;
      console.log(stats.isFile()); // 是否是文件
      console.log(stats.size);     // 文件大小
    });
    ```

#### **(7) 流操作（处理大文件）**

- fs.createReadStream(path[, options])
  - 创建可读流，适合大文件分块读取。
- fs.createWriteStream(path[, options])
  - 创建可写流，适合大文件分块写入。



### req (Request 对象)

表示客户端的 HTTP 请求，包含请求数据和元信息。

#### 属性：

- req.query：查询字符串参数的对象。例如，GET /path?name=John 中的 { name: 'John' }。
- req.params：路由参数的对象。例如，GET /users/:id 中的 { id: '123' }。
- req.body：请求体中的数据（需使用 app.use(express.json()) 或 express.urlencoded() 中间件解析）。例如，POST 请求的 JSON 数据。
- req.headers：请求头信息的对象，例如 { 'content-type': 'application/json' }。
- req.method：请求的方法，如 'GET'、'POST'。
- req.url：请求的 URL 路径，例如 /path?name=John。
- req.ip：客户端的 IP 地址。
- req.path：请求的路径部分，不包括查询字符串。
- req.protocol：请求协议，如 'http' 或 'https'。
- req.hostname：请求的主机名。
- req.originalUrl：完整的原始 URL，包括查询字符串。

#### 方法：

- req.get(headerName)：获取指定请求头的值，例如 req.get('content-type')。
- req.accepts(types)：检查客户端接受的 MIME 类型，例如 req.accepts('json')。
- req.is(type)：检查请求的 Content-Type，例如 req.is('json')。

### res (Response 对象)

表示服务器的 HTTP 响应，用于向客户端发送数据。

#### 属性：

- res.statusCode：HTTP 状态码（默认 200），可手动设置，如 res.statusCode = 404。
- res.headersSent：布尔值，表示是否已发送响应头。

#### 方法：

- res.status(code)：设置 HTTP 状态码，返回 res 本身，便于链式调用，例如 res.status(404)。
- res.json([body])：以 JSON 格式发送响应数据，例如 res.json({ message: 'Success' })。
- res.send([body])：发送各种类型响应（字符串、对象、缓冲区等），会自动设置 Content-Type。
- res.sendFile(path, [options], [callback])：发送文件，例如 res.sendFile('/path/to/file.txt')。
- res.end([data], [encoding])：结束响应过程，可选发送数据。
- res.redirect([status], path)：重定向到指定路径，例如 res.redirect('/login')（默认状态码 302）。
- res.set(field, [value])：设置响应头，例如 res.set('Content-Type', 'text/plain')。
- res.get(field)：获取已设置的响应头值。
- res.cookie(name, value, [options])：设置 Cookie，例如 res.cookie('name', 'value', { maxAge: 900000 })。
- res.clearCookie(name, [options])：清除 Cookie。
- res.append(field, value)：追加响应头字段。
- res.type(type)：设置 Content-Type，例如 res.type('json')。

