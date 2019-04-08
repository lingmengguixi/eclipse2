@echo off
erlc demo2.erl
erl -s demo2 main -s init stop -noshell
pause