# GitHub Contribution 消失问题说明（精简版）

## 问题现象

修改 GitHub 账号邮箱后，个人主页上的 contribution 记录显示异常，后续继续 push 代码也没有正常计入 contribution。

## 根本原因

GitHub 的 contribution 统计依赖提交记录中的作者邮箱。

如果出现下面任一情况，就可能导致 contribution 无法正确显示：

- 提交使用的邮箱不是当前 GitHub 账号已验证的邮箱
- 历史提交使用旧邮箱，但 GitHub 账号中已不再保留该邮箱
- 本地 Git 邮箱虽然改了，但历史提交并不会自动更新

## 核心结论

1. 修改 `git config --global user.email` 只会影响之后的新提交，不会修复历史提交。
2. 如果要恢复历史 contribution，通常需要保留旧邮箱验证，或者重写历史提交邮箱后重新推送。
3. 重写历史会改变 commit hash，并且通常需要强制推送。
4. 如果仓库是单人维护，重写历史的风险相对可控；多人协作仓库则要谨慎。

## 解决办法

### 方案一：只修复后续提交

适用场景：

- 只关心以后 contribution 正常显示
- 不打算处理过去的记录

操作：

```powershell
git config --global user.name "你的GitHub用户名"
git config --global user.email "你的GitHub已验证邮箱"
```

然后后续提交都使用正确邮箱。

### 方案二：修复历史提交

适用场景：

- 想恢复过去已经丢失的 contribution

基本思路：

1. 把仓库拉到本地
2. 批量修改历史提交中的作者邮箱
3. 强制推送回 GitHub

说明：

- 这类操作一般使用 `git filter-repo` 等工具完成
- 操作前建议先拿一个仓库试验
- 成功后再批量处理其他仓库

## 常用排查命令

检查当前 Git 身份：

```powershell
git config --global user.name
git config --global user.email
```

检查仓库最近一次提交邮箱：

```powershell
git log -1 --pretty=full
```

检查 GitHub CLI 登录状态：

```powershell
gh auth status
```

## 注意事项

- `git log` 必须在具体仓库目录里运行
- `HTTPS` 比 `SSH` 更适合快速上手
- 删除仓库前先确认该仓库是否还承载你想保留的 contribution 记录
- contribution 格子的颜色深浅主要看对应日期的贡献数量，不是看邮箱新旧

## 一句话总结

这类问题本质上不是 GitHub “丢数据”，而是提交邮箱和 GitHub 账号邮箱的关联没有对上。只改本地邮箱只能修复以后，想修复过去，通常必须处理历史提交。
