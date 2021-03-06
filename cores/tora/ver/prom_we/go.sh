#!/bin/bash

JAPROM=$JTGNG/rom/tora/"Tora e no Michi (Japan)".rom
USAROM=$JTGNG/rom/tora/JTTORA.rom
F1DROM=$JTGNG/rom/f1dream/JTF1DREAM.rom

iverilog test.v ../../hdl/jttora_{dwnld,prom_we}.v $JTGNG/modules/jtgng_obj32.v \
    -D ROM_LEN=22\'h1F2000 -D PROM_W=2 -D SIMULATION \
    -D ROM_PATH=\""$USAROM"\" \
    -o sim \
    && sim -lxt