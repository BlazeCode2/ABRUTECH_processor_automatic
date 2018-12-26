import cv2
from compile import compile 
import numpy as np
import matplotlib.pyplot as plt

im_in = cv2.imread('iron-man-3.png', cv2.IMREAD_GRAYSCALE)

d_mem = np.reshape(im_in, [512*512,], order = 'F').tolist()
#d_mem = np.zeros([512*512], dtype = np.uint8).tolist()

reg = {'PC': 0, 'MIDR': 0, 'MDAR': 0, 'MDDR': 0, 'ART': 0, 'ARG': 0
        , 'AWT': 0, 'AWG': 0, 'AC': 0, 'K0': 0, 'K1': 0, 'G0': 0, 'G1': 0, 
        'G2': 0, 'Z': 0, 'ZT': 0, 'ZRG': 0, 'ZRT': 0, 'ZK0':0, 'ZK1':0
        , 'ref_ART':0, 'ref_ARG':0, 'ref_AWT':0, 'ref_AWG':0
        , 'ref_K0':0, 'ref_K1':0, 'f_K1':1, 'f_K2': 1}

reg_bits = {'PC': 8, 'MIDR': 8, 'MDAR': 18, 'MDDR': 8, 'ART': 9, 'ARG': 9
        , 'AWT': 9, 'AWG': 9, 'Z': 0, 'ZT': 1, 'ZRG': 1, 'ZRT': 1
        , 'AC': 10, 'K0': 8, 'K1': 8, 'G0': 8, 'G1': 8, 'G2': 8 
        , 'ref_ART':9, 'ref_ARG':9, 'ref_AWT':9, 'ref_AWG':9
        , 'ref_K0':1, 'ref_K1':1, 'ZK0':1, 'ZK1':1}

no_of_breaks = {}

def imshow(arg):
    if(arg == 'in'):
        cv2.imshow('Input Image', im_in)
        cv2.waitKey(0)
        cv2.destroyAllWindows()
        
    elif(arg != 'both'):
        
        im_out = np.transpose(np.reshape(np.array(d_mem, dtype = np.uint8), arg))
        
        cv2.imshow('Output Image', im_out)
        cv2.waitKey(0)
        cv2.destroyAllWindows()
    else: #Print both
        if(reg['ZT'] == 0):
            last_address = reg['AWG'], reg['AWT']
        else:
            last_address = reg['AWT'], reg['AWG']
            
        im_out = np.transpose(np.reshape(np.array(d_mem, dtype = np.uint8), 
                                         [512,512])[0:last_address[0], 0:last_address[1]])
        #im_out = np.transpose(np.reshape(np.array(d_mem, dtype = np.uint8), [512,512]))
        
        cv2.imshow('Input Image', im_in)
        cv2.imshow('Output Image', im_out)
        cv2.waitKey(0)
        cv2.destroyAllWindows()
        
def INPC():
    reg['PC'] = reg['PC'] + 1
    
    if(reg['PC'] < len(i_mem)):
        reg['MIDR'] = i_mem[reg['PC']]
    else:
        print(reg['PC'])
    
def updateZ():
    if(reg['AC'] == 0):
        reg['Z'] = 1
    else:
        reg['Z'] = 0
        
def updateZRG():
    if(reg['ARG'] == reg['ref_ARG']):
        reg['ZRG'] = 1
    else:
        reg['ZRG'] = 0

def updateZRT():
    if(reg['ART'] == reg['ref_ART']):
        reg['ZRT'] = 1
    else:
        reg['ZRT'] = 0
        
def updateZK0():
    if(reg['K0'] ==  reg['ref_K0']):
        reg['ZK0'] = 1
    else:
        reg['ZK0'] = 0
        
def updateZK1():
    if(reg['K1'] == reg['ref_K1']):
        reg['ZK1'] = 1
    else:
        reg['ZK1'] = 0
        
def updateREG(reg_name):
    maxVal = 2**reg_bits[reg_name]
    reg[reg_name]  =  reg[reg_name] % maxVal

def TOGL():
    if(reg['ZT'] == 0):
        reg['ZT'] = 1
    else:
        reg['ZT'] = 0
    INPC()
    
def LOAD():            
    if(param == 'FROM_ADR'):
        pass
    elif(param == 'FROM_MAT'):
        if(reg['ZT'] == 0):
            reg['MDAR'] = reg['ARG']*512 + reg['ART']
        else:
            reg['MDAR'] = reg['ART']*512 + reg['ARG']
    else:
        print("ERROR. Parameter mismatch in LOAD")
        
    reg['MDDR'] = d_mem[int(reg['MDAR'])]
    INPC()
    
def LADD():
    INPC()
    addr = reg['MIDR']
    INPC()
    
    first_half = int(addr/512)
    second_half = addr % 512
    
    if(param == 'TO_MDAR'):
        reg['MDAR'] = addr
    elif(param == 'TO_AR'):
        if(reg['ZT'] == 0):
            reg['ARG'] = first_half
            reg['ART'] = second_half
        else:
            reg['ART'] = first_half
            reg['ARG'] = second_half
    elif(param == 'TO_AW'):
        if(reg['ZT'] == 0):
            reg['AWG'] = first_half
            reg['AWT'] = second_half
        else:
            reg['AWT'] = first_half
            reg['AWG'] = second_half
    elif(param == 'TO_AR_REF'):
        if(reg['ZT'] == 0):
            reg['ref_ARG'] = first_half
            reg['ref_ART'] = second_half
        else:
            reg['ref_ART'] = first_half
            reg['ref_ARG'] = second_half
    else:
        print("Parameter error in LADD")
    
    updateZRG();
    updateZRT();
    
def LODK():
    INPC()
    reg['AC'] = int(reg['MIDR'])
    INPC()
    
    updateZ()

def STAC():
    if(param == 'TO_ADR'):
        pass
    elif(param == 'TO_MAT'):
        if(reg['ZT'] == 0):
            reg['MDAR'] = reg['AWG']*512 + reg['AWT']
        else:
            reg['MDAR'] = reg['AWT']*512 + reg['AWG']
    else:
        print("ERROR. Parameter mismatch in STAC")
        
    reg['MDDR'] = reg['AC']
    updateREG('AC')
    d_mem[int(reg['MDAR'])] = reg['MDDR']
    INPC()
    
def COPY():
    INPC()
    operand = reg['MIDR']
    INPC()
    
    from_reg = operand[0]
    to_reg_list = operand[1]
    
    if(to_reg_list == ['ALL']):
        for register in reg_bits.keys():
            if(reg_bits[register] == 8 and register not in ['PC', 'MIDR']):
                reg[register] = reg[from_reg]
                
                updateREG(register)
                
                if(register == 'K0' and reg['K0'] == 1):
                    reg['ref_K0'] = reg[from_reg]
                    reg['f_K0'] == 0
                if(register == 'K1' and reg['K1'] == 1):
                    reg['ref_K1'] = reg[from_reg]
                    reg['f_K1'] == 0
                
            
    else:
        for to_reg in to_reg_list:
            if(to_reg == 'G0'):
                reg['G2'] = reg['G1']
                reg['G1'] = reg['G0']
                reg['G0'] = int(reg[from_reg])
                updateREG('G0')
            else:
                reg[to_reg] = reg[from_reg]
                updateREG(to_reg)
                
                if(to_reg == 'K0' and reg['K0'] == 1):
                    reg['ref_K0'] = reg[from_reg]
                    reg['f_K0'] == 0
                if(to_reg == 'K1' and reg['K1'] == 1):
                    reg['ref_K1'] = reg[from_reg]
                    reg['f_K1'] == 0
    
                
def JUMP():
    INPC()
    addr = int(reg['MIDR'])
    INPC()
    
    updateZ()
    updateZRG()
    updateZRT()
    updateZK0()
    updateZK1()
    
    j        = (param == 'J')
    j_ZAC    = (param == 'Z_AC'      and reg['Z']    == 1)
    j_NZAC   = (param == 'NZ_AC'     and reg['Z']    == 0)
    j_ZT     = (param == 'Z_TOG'     and reg['ZT']   == 1)
    j_NZRT   = (param == 'NZ_ART'    and reg['ZRT']  == 0)
    j_NZRG   = (param == 'NZ_ARG'    and reg['ZRG']  == 0)
    j_NZK0   = (param == 'NZ_K0'     and reg['ZK0']  == 0)
    j_NZK1   = (param == 'NZ_K1'     and reg['ZK1']  == 0)
    
    j_now = j or j_ZAC or j_NZAC or j_ZT or j_NZRT or j_NZRG or j_NZK0 or j_NZK1
    
    if(j_now):
        reg['PC'] = addr
        reg['MIDR'] = d_mem[reg['PC']]
    

def INCR():
    INPC()
    operand = reg['MIDR']
    INPC()
    operands = operand.replace(' ', '').split(',')
    
    
    for register in operands:
        reg[register] = reg[register] + 1
        updateREG(register)
    
def DECR():
    INPC()
    operand = reg['MIDR']
    INPC()
    
    operands = operand.replace(' ', '').split(',')
    
    for register in operands:
        reg[register] = reg[register] - 1
        updateREG(register)    
    
def RSET():
    INPC()
    operand = reg['MIDR']
    INPC()
    
    if(operand == 'ALL'):
        for register in reg_bits.keys():
            if(reg_bits[register] != 1 and register not in ['PC', 'MIDR']):
                reg[register] = 0
                updateREG(register)
                updateZ()
                updateZRG()
                updateZRT()
    else:
        operands = operand.replace(' ', '').split(',')
        for register in operands:
            reg[register] = 0
    
def ADD():
    INPC()
    operand = reg['MIDR']
    INPC()
    
    reg['AC'] = reg['AC'] + reg[operand]
    
    updateREG('AC')
    
def SUBT():
    INPC()
    operand = reg['MIDR']
    INPC()
    
    reg['AC'] = abs(reg['AC'] - reg[operand])
    
    updateREG('AC')
    
def DIV():
    INPC()
    operand = reg['MIDR']
    INPC()
    
    reg['AC'] = int(round(float(reg['AC']) / float(operand),0))
    
    updateREG('AC')
    
def NOOP():
    INPC()

def END():
    print('END reached')
    
instructions = {'TOGL': TOGL, 'LOAD': LOAD, 'LADD': LADD, 
                'LODK' : LODK, 'STAC': STAC, 'JUMP' : JUMP, 'ADD': ADD, 
                'INCR': INCR,  'DECR': DECR, 'DIV': DIV, 'SUBT': SUBT, 
                'RSET': RSET, 'COPY': COPY, 'NOOP': NOOP, 'END':END}

stop_breaks = False
step = False
i_mem = compile('DIVdownsample.txt')
reg['MIDR'] = i_mem[0]
param = '';