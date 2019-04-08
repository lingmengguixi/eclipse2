@echo off
erlc demo11.erl
erl -s demo11 start -sname server
pause