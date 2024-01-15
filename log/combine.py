import os

os.chdir('../export')
all_files = os.listdir()

caf = 0
for file in all_files:
    if file.endswith('.log'):
        caf += 1

c = 1
with open('combined.log', 'w') as cf:
    for file in all_files:
        if file.endswith('.log'):
            with open(file, 'r') as f:
                cf.write(f.read())
                cf.write(' == ' * 30 + '\n')
            print(f"\r\r{c} of {caf} done.", end="")
            c += 1

print('Finished.')
