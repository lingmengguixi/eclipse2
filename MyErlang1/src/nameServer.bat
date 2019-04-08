@echo off
erlc nameServer.erl
erl -sname server -s nameServer start