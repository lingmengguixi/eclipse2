@echo off
set /p name="输入客户名称:"
echo 名称:%name%
erlc nameClient.erl
erl -sname %name%