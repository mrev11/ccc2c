@echo off
if     [%cccbin%]==[clp] call bapp_clp
if not [%cccbin%]==[clp] call bapp_w32c
 