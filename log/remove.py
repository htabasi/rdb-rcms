with open('BUZ_RX_V1M.log', 'r') as f:
    r = [line for line in f.readlines() if 'DEBUG' in line]

with open('BUZ_RX_V1M-Corrected.log', 'w') as f:
    for line in r:
        f.write(line[64:])
