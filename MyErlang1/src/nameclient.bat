@echo off
set /p name="����ͻ�����:"
echo ����:%name%
erlc nameClient.erl
erl -sname %name%