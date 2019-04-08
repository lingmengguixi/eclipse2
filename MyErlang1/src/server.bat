@echo off
erlc server1.erl
erl -s server1 start -s init stop -noshell
pause