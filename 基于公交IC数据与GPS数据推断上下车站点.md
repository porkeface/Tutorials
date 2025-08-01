<h1 align = "center">基于公交IC数据与GPS数据推断上下车站点</h1>



## 公交IC卡和GPS数据

### 	公交IC卡数据

​	**公交IC卡的数据是乘客上车刷卡时记录下来的。公交IC卡数据信息表(表1)主要记录了持卡者 的上车时间点和车辆线路信息,通常包括以下11个字段:==线路编码==、==车牌号==、==IC卡号==、==刷卡日期==、==刷卡时 间==、==流水号==、==线路车票金额==、==实际消费金额==、==IC卡余额==、==消费类型==和==运营公司==。**

![image-20250306190435177](C:\Users\Hxxim\AppData\Roaming\Typora\typora-user-images\image-20250306190435177.png)

### 	GPS数据

​	**全球定位系统(GPS)可以实时监测汽车的位置,随着技术的发展,其精度也越来越高。GPS的应用 已不局限于车辆的导航上,它已经应用于跟踪车辆的运动轨迹。公交GPS系统记录了公交车辆的位 置数据,主要包括以下字段:==线路号==、==车牌号==、==上下行编码==、==站点名称==、==车辆进站时间==、==车辆出站时间==。**

![image-20250306191304466](C:\Users\Hxxim\AppData\Roaming\Typora\typora-user-images\image-20250306191304466.png)

---



## 上车站点匹配

​	**如图1所示,通过车牌号可以将每条IC卡数据与对应车辆的GPS数据进行匹配。 若IC卡系统的 时间跟GPS系统的时间一致==, IC卡的刷卡时间应该处于车辆在对应上车站点的进站时间与其在下一 个站点的进站时间之间,==据此,可以将每条IC卡数据与对应GPS数据匹配,GPS数据记录的站点即为该 条IC卡的上车站点,IC卡刷卡时间即为上车时间;若IC卡系统时间跟GPS系统时间不一致,则需要对 系统时间进行修正。**

![image-20250306191706042](C:\Users\Hxxim\AppData\Roaming\Typora\typora-user-images\image-20250306191706042.png)

---



##  下车站点推断

​	区分工作日与休息日

​	**下车站点的推断主要是基于3个假设:**

​	**==一是公交乘客下次乘车的上车站点是或者靠近前次乘车的下车站点==;**

​	**==二是公交乘客当日最后一次乘车的下车站点是或者靠近当日或次日第一次乘车的上车站点==;**

​	 **==三是前次乘车的下车站点与后次乘车的上车站点间的距离应在乘客可承受的步行距离内==。**

![image-20250306192350151](C:\Users\Hxxim\AppData\Roaming\Typora\typora-user-images\image-20250306192350151.png)

​	**统计频率、计算概率**

​	

​	吸引度





























- **加速科研：AI在药物研发中筛选分子（如Insilico Medicine缩短新药研发周期至2年），AlphaFold预测了2亿种蛋白质结构，推动生物学革命。**
- **应对气候变化：AI优化能源使用（如谷歌DeepMind降低数据中心能耗40%），预测极端天气（如IBM的Green Horizon项目）**

+ **脑机接口：探索AI与人脑的交互**