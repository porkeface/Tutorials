在微信小程序中，`this`和`page` 数据相同，是因为 **`page` 参数实际上就是指向当前页面实例的 `this`**。以下是详细解释：

---

### 1. **`page` 的来源**
在调用 `initChart` 时，通常会传入当前页面的 `this` 作为 `page` 参数，例如：
```javascript
// 页面 JS 中调用 initChart
initChart(canvas, width, height, dpr, this); // 这里的 this 是页面实例
```
此时，`page` 就是当前页面的 `this`，两者完全指向同一个对象。

---

### 2. **`this` 和 `page` 的等价性**
- 在页面方法中直接通过 `this` 访问的属性（如 `this.allNodes`），和通过 `page` 访问的属性（如 `page.allNodes`），本质上是同一个内存地址的引用。
- 例如：
  ```javascript
  Page({
    onLoad() {
      initChart(canvas, width, height, dpr, this); // 传入 this 作为 page
    },
    methodA() {
      console.log(this === page); // 如果 page 是传入的 this，这里输出 true
      console.log(this.allNodes === page.allNodes); // true，指向同一数据
    }
  });
  ```

---

### 3. **数据同步的原理**
- **赋值行为**：  
  在 `wx.request` 的成功回调中，您通过 `page.allNodes = res.data.nodes` 修改了 `page` 的属性。由于 `page` 就是 `this`，所以 `this.allNodes` 也会同步变化。
  ```javascript
  wx.request({
    success(res) {
      page.allNodes = res.data.nodes; // 等同于 this.allNodes = res.data.nodes
    }
  });
  ```

- **引用类型特性**：  
  JavaScript 中对象是引用类型，`page` 和 `this` 指向同一个对象，因此修改其中一个的属性会直接影响另一个。

---

### 4. **关键注意事项**
1. **直接赋值 vs `setData`**  
   - `this.allNodes` 和 `page.allNodes` 是直接挂载到页面实例上的自定义属性，**不会触发视图渲染**。  
   - 如果需要更新页面显示，必须使用 `this.setData({ allNodes: res.data.nodes })`。

2. **箭头函数的替代方案**  
   如果使用箭头函数，可以避免传递 `page` 参数，直接通过 `this` 访问实例：
   ```javascript
   wx.request({
     success: (res) => {
       this.allNodes = res.data.nodes; // 箭头函数继承外层 this
     }
   });
   ```

3. **调试验证**  
   可以通过打印 `this === page` 或比较属性引用来确认两者是否一致：
   ```javascript
   console.log(this === page); // true
   console.log(this.allNodes === page.allNodes); // true
   ```

---

### 5. **总结**
| 现象                              | 原因                                                    |
| --------------------------------- | ------------------------------------------------------- |
| `this.allNodes === page.allNodes` | `page` 是传入的 `this`，两者指向同一个对象。            |
| 数据同步                          | JavaScript 对象的引用特性导致修改一处，另一处同步变化。 |
| 视图更新                          | 直接赋值不会触发渲染，需用 `setData`。                  |

**根本原因**：`page` 就是 `this` 的“别名”，操作 `page` 等同于操作 `this`。