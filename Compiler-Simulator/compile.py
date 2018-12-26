from read_isa import *
import binascii
import pandas as pd
import numpy as np
import os

def compile(fname):
    isa, isa_dict = read_isa()
    
    
    program_fName = fname
    program_file  = open(program_fName)
    
    reg_inc = {'MDAR':0, 'ART':1, 'ARG':2, 'AWT':3, 'AWG':4, 'AC':5, 'K0':6, 'K1':7}
    reg_from   = {'AC':0, 'MDDR':1, 'K0':2, 'K1':3,
                'G0':4, 'G1':5, 'G2':6, 'MIDR':7}
    reg_to   = {'AC':0,'MDDR':1, 'K0':2, 'K1':3,
                'G0':4}
    
    parameters = { 'LOAD':{'FROM_ADR':0, 'FROM_MAT':1}, 
                   'LADD':{'TO_MDAR':6, 'TO_AR':7, 'TO_AW':8, 'TO_AR_REF':9, 'TO_AW_REF':10}, 
                   'STAC':{'TO_ADR':0, 'TO_MAT':2}, 
                   'JUMP':{'J':1,'Z_AC':2,'NZ_AC':3,'Z_TOG':4,'NZ_ARG':5,'NZ_ART':6,'NZ_K0':7,'NZ_K1':8}
            }
  
    binary_name = 'binary.txt'
    binary_txt = open(binary_name, "w") 
    
    lineNo = 0;
    loop = {}
    
    last_opcode = ""
    
    isError = False
    
    program = []
    program_binary = []
    
    for line in program_file:
        
        line = line.strip()
        
        if(len(line) == 0):
            continue;
        
        if(line[0][0] == '$'):                         #loop reference
            words = line.split()
            loop[words[0][1:].upper()] = lineNo
            del words[0]
            line = ''.join(words)
        
        if(len(line) == 0):
            continue;
        
        line = line.replace(' ', '').replace('\t', '')
                
        
        if(line[0] == '#'):                         #comment
            continue
        words = line.split('#')
            
        if(len(words) == 0):
            continue
            
        word = words[0].upper()                     #Word is operand or opcode or opcode:parameter 
        
        
        if (word[0] == '['):                        #Operand
            lineNo += 1
            operand_type = isa['Op'][last_opcode]
            word = word.replace('[', '').replace(']', '').strip()
            
            if(operand_type == 'A'):
                program_binary.append(word)
                program.append(word)
                continue
                
            elif(operand_type == 'I'):
                operands = word.replace(' ', '').split(',')
                binary_operand = 0
                
                if(len(operands) > 0 and operands[0] == 'ALL'):
                    program_binary.append(str(255))
                    program.append('ALL')
                    continue
                
                for given_reg in operands:
                    if(given_reg in reg_inc):
                        binary_operand += 2**reg_inc[given_reg]
                    else:
                        print ('''Error: Word '%s' in line %s. Expected a 
                               register name which can be incremented, decremented or reset''' % (word, lineNo))
                        isError = True
                        break
                if(isError):
                    break
                
                program_binary.append(str(binary_operand))
                program.append(word)
                continue
                
            elif(operand_type == 'K'):
                if(word.isnumeric):
                    if(int(word) < 256):
                        program_binary.append(word)
                        program.append(word)
                        continue
                print ('''Error: Word '%s' in line %s. Expected a 
                           number < 256''' % (word, lineNo))
                isError = True
                break            
            elif(operand_type == 'RR'):
                if(word in reg_from):
                    program_binary.append(str(reg_from[word]))
                    program.append(word)
                    continue
                else:
                    print ('''Error: Word '%s' in line %s. Expected a 
                           register which can be read into A bus''' % (word, lineNo))
                    isError = True
                    break
                
            elif(operand_type == 'RW'):
                                  
                try:
                    if('->' in word):
                        operands = word.replace(' ', '').split('->')  
                        from_reg = operands[0]
                        to_reg_list = operands[1].split(',')
                    elif('<-' in word):
                        operands = word.replace(' ', '').split('<-')  
                        from_reg = operands[1]
                        to_reg_list = operands[0].split(',')
                    else:
                        print ("Invalid COPY operands in word '%s' in line %s"% (word, lineNo))
                        isError = True
                        break
                except:
                    print ('''Error: Word '%s' in line %s. At least two registers should be specified''' % (word, lineNo))
                    isError = True
                    break
                
                to_reg_binary_sum = 0
                
                if(to_reg_list == ['ALL']):
                    binary_operand = reg_from[from_reg]*32 + 31
                    program_binary.append(str(binary_operand))
                    program.append([from_reg, to_reg_list])
                    continue;
                    
                elif(from_reg in reg_from and len(to_reg_list) != 0):
                    try:
                        for to_reg in to_reg_list:
                            to_reg_binary_sum += 2**reg_to[to_reg]
                    except:
                        print ('''Error: Word '%s' in line %s. Expected a 
                           register which can be written into A bus
                           and a register that can write into A bus''' % (word, lineNo))
                        isError = True
                        break
                    
                    binary_operand = reg_from[from_reg]*32 + to_reg_binary_sum
                    program_binary.append(str(binary_operand))
                    program.append([from_reg, to_reg_list])
                    continue
                
                else:
                    print ('''Error: Word '%s' in line %s. Expected a 
                           register which can be written into A bus
                           and a register that can write into A bus''' % (word, lineNo))
                    isError = True
                    break
                
            elif(operand_type == '3A'):
                addr = -1
                
                
                if(',' in word):
                    coords = word.split(',')
                    
                    if(len(coords) == 2):
                        first_half = coords[0]
                        second_half = coords[1]
                        
                        if(first_half.isnumeric and second_half.isnumeric):
                            first_half = int(first_half) % 512
                            second_half = int(second_half) % 512
                            
                            addr = first_half * 512 + second_half
                    
                elif(word.isnumeric):
                    addr = int(word)
                            
                if(addr >= 0 and addr < 512*512 ):
                    first8 = int(addr/2**16)
                    reminder = addr % (2**16)
                    
                    mid8 = int(reminder/2**8)
                    last8 = reminder % (2**8)
                    
                    program_binary.extend([first8, mid8, last8])
                    program.append(addr)
                    program.append('-')
                    program.append('-')
                    lineNo += 2
                    continue
                
                print ('''Error: Word '%s' in line %s. Expected a 
                           number < 512*512''' % (word, lineNo))
                isError = True
                break
        
        word_split = word.split(':')
        
        opcode = word_split[0]       
    
        if (opcode in isa_dict['BIN'].keys()):        #Opcode
            lineNo += 1
            last_opcode = opcode;
            
            param = '-'
            param_binary = 0
            
            if(len(word_split) > 1):
                param = word_split[1]
                
                if(param == '-'):
                    if   (opcode == 'LOAD'):
                        param = 'FROM_MAT'
                    elif (opcode == 'STAC'):
                        param = 'TO_MAT'
                    elif (opcode == 'LADD'):
                        param = 'TO_MDR'
                
                try:
                    if(opcode in ['ADD', 'SUBT']):
                        param_binary = reg_from[param]
                    else:
                        param_binary = parameters[opcode][param]
                except:
                    print("Operand-Parameter mismatch in line %s, word %s with operand %s, parametr %s" 
                          %(lineNo, word, opcode, param))
                    isError = True;
                    break;
                
            opcode_binary = isa['BIN'][opcode]
            output_binary = int(opcode_binary) + int(param_binary)
            
            
            program_binary.append(output_binary)
            program.append([opcode, param])
            continue
        
        if(isError == True):
            print("Error Found in line %s in word '%s' " %(lineNo, word))   
            
    if(lineNo - 1 > 256):
        print ("Error: Program is more than 256 bytes long. Cannot be stored in memory")
        isError = True
    
    for i in range(len(program_binary)):
        word = program_binary[i]
        if(type(word) == int ):
            binary_txt.write(str(word) + '\n')
        elif(word.isnumeric()):
            binary_txt.write(word + '\n')
        else:
            if(word in loop.keys()):
                binary_txt.write(str(loop[word]) + '\n')
                program[i] = loop[word]
            else:
                print ('''Error: loop reference not found 
                           for word '%s' in line %s''' % (word, i+1))
                isError = True
    
    program_file.close()
    binary_txt.close()
    
    binary_txt = open(binary_name, 'ab')            #To remove the last newline
    binary_txt.seek(-2, os.SEEK_END)
    binary_txt.truncate()
    binary_txt.close()
    
    if(not isError):
        print("Compilation Successful, with no errors\n")
    
    return program