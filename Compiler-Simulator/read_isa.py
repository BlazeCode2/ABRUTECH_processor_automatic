import pandas as pd
import numpy as np
import sys
sys.path.append('../')

file_name = 'Instruction Set.xlsx'

isa_file = pd.ExcelFile(file_name)
    
def read_isa():
    isa_df = isa_file.parse('ISA')
    isa_df = isa_df[isa_df['Op'].notnull()]
    isa_df = isa_df[isa_df['BIN'].notnull()]
    isa_df = isa_df.fillna(0)
    isa_df = isa_df[['OPCODE', 'BIN', 'Op']]
    isa_df = isa_df.set_index('OPCODE')
    isa_df[['BIN']] = isa_df[['BIN']].astype(np.uint16)
    isa_df[['BIN']] = isa_df[['BIN']].astype(np.str)
   
    isa_dict = isa_df.to_dict()
    
    return isa_df, isa_dict

def read_ins():
    ins_df = isa_file.parse('u-ins')
    
    ins_df = ins_df[ins_df['u-ins'].notnull()]
    ins_df = ins_df.fillna(0)
    ins_df = ins_df[['u-ins', 'N']]
    ins_df = ins_df.set_index('u-ins')
    ins_df[['N']] = ins_df[['N']].astype(np.uint16)
    ins_df[['N']] = ins_df[['N']].astype(np.str)
    
    ins_dict = ins_df.to_dict()
    
    return ins_df, ins_dict




