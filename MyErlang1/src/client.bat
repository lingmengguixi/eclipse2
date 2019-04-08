@echo off
erlc client1.erl
erl -s client1 start -s init stop -noshell
pause