import os


def convert_dir(directory_path):
    print(f'  ---   Starting to Convert directory {directory_path}   ---')

    mp3_list = [file_name for file_name in os.listdir(directory_path) if file_name.endswith('.mp3')]
    ffmpeg_path = 'C:\\ffmpeg\\bin\\ffmpeg.exe'
    output_base = 'E:\\converted\\'
    command = (f'{ffmpeg_path} -i {directory_path}\\{{}} -codec: copy -start_number 0 -hls_time 10 '
               f'-hls_list_size 0 -f hls {{}}\\{{}} > {output_base}normal_log.txt 2>{output_base}error_log.txt')

    length = len(mp3_list)
    for i, mp3 in enumerate(mp3_list):
        base_name = mp3[:-4]
        print(f'\r{" " * 100}', end='')
        print(f'\rStarting to Convert ({i + 1} of {length}) {mp3}', end='')
        os.makedirs(f'{output_base}\\{base_name}', exist_ok=True)
        c = command.format(mp3, f'{output_base}\\{base_name}', f'{base_name}.m3u8')
        os.system(c)
    print(f'\rStarting to Convert ({length} of {length}) completed.                                  ')


directory_list = [u'E:\\manz', u'E:\\manz\\masn']
for directory in directory_list:
    convert_dir(directory)
