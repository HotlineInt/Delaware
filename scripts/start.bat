@echo off

echo Updating..
git submodule update --remote
echo Starting..
hojo serve ../