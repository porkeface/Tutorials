@echo off
echo ����ִ�� Git �Զ��ύ������...
echo.

:: ����Ƿ��� Git �ֿ���
git rev-parse --is-inside-work-tree >nul 2>&1
if %errorlevel% neq 0 (
    echo ���󣺵�ǰĿ¼���� Git �ֿ⣡
    pause
    exit /b
)

:: ����Ƿ����ļ����
git diff --quiet
if %errorlevel% equ 0 (
    echo û���ļ�����������ύ��
    pause
    exit /b
)

:: ִ�� Git ����
git add . || (
    echo ����git add ʧ�ܣ�
    pause
    exit /b
)

git commit -m "�����ύ" || (
    echo ����git commit ʧ�ܣ�
    pause
    exit /b
)

git push || (
    echo ����git push ʧ�ܣ�
    pause
    exit /b
)

echo.
echo �����ɹ���ɣ�
pause