@echo off
echo 正在执行 Git 自动提交并推送...
echo.

:: 进入当前脚本所在目录（可选，如果脚本和仓库不在同一目录需修改）
cd /d "%~dp0"

:: 执行 Git 命令
git add .
git commit -m "更新提交"
git push

echo.
echo 操作完成！
pause