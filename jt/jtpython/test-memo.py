#! /usr/bin/env python
# _*_ coding: latin-1 _*_
 
from jtlib import *

input_txt=jtutil.memoread("proba.txt") 
output_txt=jtmemo.jtmemoedit(2,5,20,80,input_txt)

if output_txt and output_txt != input_txt:
    jtutil.memowrit("proba.txt",output_txt)
