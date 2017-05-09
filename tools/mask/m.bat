@echo off

pushd msk2say
call m.bat
popd


bapp_w32c -xmask -xpage @parfile.bld
bapp_w32_ -xmsk2pge -xpge2wro @parfile.bld
