import os

lc = 0
errors = []
warnings = []

os.chdir('../export')
with open('combined.log', 'r') as cf:
    afc = cf.readlines()
    while afc:
        line = afc.pop(0)
        lc += 1
        if '[Errno 32] Broken pipe' in line:
            continue
        if 'Query:INSERT INTO Common.CBITList' in line:
            for i in range(11):
                afc.pop(0)
                lc += 1

            continue
        if 'ERROR' in line:
            errors.append((lc, line))
        if 'WARNING' in line:
            warnings.append((lc, line))

with open('errors.log', 'w') as ef:
    for c, line in errors:
        ef.write(f"{c}: {line}")

with open('warnings.log', 'w') as ef:
    for c, line in warnings:
        ef.write(f"{c}: {line}")
