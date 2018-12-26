# -*- coding: utf-8 -*-
"""
Created on Sat May 26 08:13:56 2018

@author: Aba
"""

from compile import *
from processor import *
from make_define import *

print('''
---------------------------------------------------------------------
Greetings!

This program does the following actions for a program
written for the version 5.6 of the CART / ABRUTECH custom matrix-manipulating
processor.

1. Reading the ISA specfied in Excel file
2. Generating Opcode_define Verilog file
3. Syntax-Checking your program written in human language
4. Compiling / Assembling your program into the binary text file
5. Simulating your program by executing the same exact steps of the processor

''')

while(True):    
    fname = input('Input file name: ')
    option = input('''Do you wish to simulate? [y/n]: ''')
    try:
        make_define()
        if(fname[-4:] == '.txt'):
            fname = fname[:-4]
            
        if(fname == ''):
            fname = 'div4ds'
            
        if (option == 'y'):
            option2 = input('Do you want to simulate step by step? [y/n]: ')
            if(option2 == 'y'):
                process(fname, True)
            else:
                process(fname)
        else:
            compile(fname + '.txt')
        
        exit_option = input('''\nDo you wish to exit? [y/n]: ''')
        
        if(exit_option == 'y'):
            input('Thank you for evaluating our processor. Press enter to exit.')
            break
        
    except FileNotFoundError:
        print('The file you mentioned is not found in the compile directory. Try again')
        
    print('--------------------------------------------------------------\n')
