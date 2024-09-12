from execute import get_connection, get_scalar_answer, get_simple_column, execute_no_answer_query
from time import sleep


load_radios_query = "Select Name From RCMS.Radio.Radio"
user_id_query = "Select id From RCMS.Django.account_user Where username='htabasi'"
write_command_query = "Insert Into Command.History (Radio, CKey, Request, Value, Status, user_id) "\
                      "Values ('{}', '{}', '{}', '{}', '{}', '{}')"

_connection = get_connection()
radios = get_simple_column(_connection, load_radios_query)
user_id = get_scalar_answer(_connection, user_id_query)

for radio in radios:
    execute_no_answer_query(_connection, write_command_query.format(radio, 'SCSS', 'S', 2, 1, user_id))
    sleep(0.3)
    hostname = f'"{radio}"'.replace('_', '')
    execute_no_answer_query(_connection, write_command_query.format(radio, 'GRHN', 'S', hostname, 1, user_id))
    sleep(0.3)
    execute_no_answer_query(_connection, write_command_query.format(radio, 'SCSS', 'S', 0, 1, user_id))
    print(f'Added for {radio}')
