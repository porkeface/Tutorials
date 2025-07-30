<h1 align ="center" >py2neo</h1>

## py2neo通过关系查询节点方法

* ### 使用 Cypher 查询

```python
from py2neo import Graph

# 连接到 Neo4j 数据库
graph = Graph("bolt://localhost:7687", auth=("username", "password"))

# 定义 Cypher 查询：找到与 Alice 有 FRIEND 关系的所有节点
cypher_query = """
MATCH (a:Person {name: $name})-[:FRIEND]->(friend)
RETURN friend
"""

# 执行查询
result = graph.run(cypher_query, name="Alice")

# 遍历结果
for record in result:
    friend_node = record["friend"]
    print(friend_node["name"], friend_node.labels)
```

- ### 使用 RelationshipMatcher

```python
from py2neo import Graph, NodeMatcher, RelationshipMatcher

# 连接到数据库
graph = Graph()
node_matcher = NodeMatcher(graph)
rel_matcher = RelationshipMatcher(graph)

# 1. 找到起始节点（例如 Alice）
alice = node_matcher.match("Person", name="Alice").first()

# 2. 查询从 Alice 出发的 FRIEND 关系
在 py2neo 中，rel_matcher.match((alice,), "FRIEND") 执行后返回的是一个 惰性求值的查询结果集，具体表现为一个 迭代器对象（而不是直接返回列表）
relationships = rel_matcher.match((alice,), "FRIEND")

# 3. 提取结束节点
friends = [rel.end_node for rel in relationships]

# 输出结果
for friend in friends:
    print(friend["name"], friend.labels)
```

- ### 如何处理返回值？

```shell
直接遍历（推荐）
for rel in relationships:
    print(rel.end_node["name"])
```

```shell
转换为列表
rel_list = list(relationships)
print(rel_list[0].end_node["name"])  # 访问第一个关系
```

```shell
获取单个结果
first_rel = next(relationships, None)  # 获取第一个关系，若无则返回 None
if first_rel:
    print(first_rel.end_node["name"])
```

## 查询结点

- ### 通过属性查找结点

```shell
MATCH (r)
WHERE r.`姓名` = "陈志杰"
return r
```

