@echo off
for /r %%i in (src/*.erl) do (
   echo erlc -o "%%~piebin"  %%~pisrc/%%~nxi
   erlc -o "%%~piebin"  %%~pisrc/%%~nxi
)
cd ebin
echo please enter the command to run
echo eg:run or use erl to run
