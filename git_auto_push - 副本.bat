@echo off
echo 正在执行 Git 自动提交并推送...
echo.

:: 检查是否在 Git 仓库中
git rev-parse --is-inside-work-tree >nul 2>&1
if %errorlevel% neq 0 (
    echo 错误：当前目录不是 Git 仓库！
    pause
    exit /b
)


:: 执行 Git 操作
git add . || (
    echo 错误：git add 失败！
    pause
    exit /b
)

git commit -m "更新提交" || (
    echo 错误：git commit 失败！
    pause
    exit /b
)

git push || (
    echo 错误：git push 失败！
    pause
    exit /b
)

echo.
echo 操作成功完成！
pause