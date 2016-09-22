@echo off
call clean.bat
javac jterminal.java 2>log
call mkjar.bat
type log
