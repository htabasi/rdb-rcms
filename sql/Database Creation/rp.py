s = """;
INSERT INTO RCMS.Command.KeyInformation (CKey, TX_Name, RX_Name, Parameter_Type, Parameter_Unit, INT_Parameter_Min,
                                         INT_Parameter_Max, INT_Parameter_Step, FLOAT_Parameter_Min,
                                         FLOAT_Parameter_Max, FLOAT_Parameter_Step, STRING_Max_Length, Convertor_Table,
                                         RegisterTable, TX_Support, RX_Support, GET_Support, SET_Support, TRAP_Support,
                                         GET_Need_Value, Update_Need_Restart, Work_As_Expected, Fully_Identified)
VALUES """

with open('16_Fill_Command.sql', 'r') as f:
    wl = f.read()

rl = wl.replace(s, ',\n')

with open('16_Fill_Command.sql', 'w') as f:
    f.write(rl)


