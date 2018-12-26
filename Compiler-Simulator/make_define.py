from read_isa import *

def make_define():
    ins_df, ins_dict = read_ins()
    
    v_file = open('opcode_define.v', 'w')
    
    v_file.write ("// Opcodes and their binary values\n")
    
    #opcodes = isa_dict['BIN'].keys()
    u_ins = ins_dict['N'].keys()
        
    for u_in in u_ins:
        binary = ins_dict['N'][u_in]
        v_file.write("`" +"define "+ u_in.upper() + "\t" + str(binary) + '\n')
    
    print ("Opcode Define file updated successfully\n")
    v_file.close();