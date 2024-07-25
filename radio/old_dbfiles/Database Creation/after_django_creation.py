from create_database import get_connection, execute_no_answer_query, get_file, get_query_answer
import os


def get_sql_files(folder):
    folder_content = os.listdir(folder)
    return sorted([filename for filename in folder_content
                   if filename.endswith('.sql') and filename.startswith('2')])


def load_and_run(folder):
    connection = get_connection()
    sql_files = get_sql_files(folder)
    for filename in sql_files:
        statements = get_file(filename)
        for statement in statements:
            answer = execute_no_answer_query(connection, statement)
            # print(statement)
            if answer is None:
                return
            else:
                print(f'--> {answer} rows affected.')


def make_group_permission_file():
    connection = get_connection()
    p = {
        1: ('AIAD', 1, 1, 1, 0, 0),
        2: ('AIAI', 1, 1, 0, 0, 0),
        3: ('AICA', 1, 1, 0, 0, 0),
        4: ('AIEL', 1, 1, 0, 0, 0),
        5: ('AIGA', 1, 1, 0, 0, 0),
        6: ('AILA', 1, 1, 1, 0, 0),
        7: ('AIML', 1, 1, 0, 0, 0),
        8: ('AISE', 1, 1, 0, 0, 0),
        9: ('AISF', 1, 1, 0, 0, 0),
        10: ('AISL', 1, 1, 1, 0, 0),
        11: ('AITP', 1, 1, 0, 0, 0),
        12: ('AITS', 1, 1, 0, 0, 0),
        13: ('EVCL', 1, 1, 0, 0, 0),
        14: ('FFBL', 1, 1, 0, 0, 0),
        15: ('FFCO', 1, 1, 0, 0, 0),
        16: ('FFEA', 1, 1, 0, 0, 0),
        17: ('FFFE', 1, 1, 0, 0, 0),
        18: ('FFLM', 1, 1, 0, 0, 0),
        19: ('FFLT', 1, 1, 0, 0, 0),
        20: ('FFMD', 1, 1, 0, 0, 0),
        21: ('FFSC', 1, 1, 0, 0, 0),
        22: ('FFSL', 1, 1, 0, 0, 0),
        23: ('FFSN', 1, 1, 1, 1, 0),
        24: ('FFSP', 1, 1, 0, 0, 0),
        25: ('FFSQ', 1, 1, 1, 0, 0),
        26: ('FFSR', 1, 1, 1, 1, 0),
        27: ('FFTO', 1, 1, 1, 0, 0),
        28: ('FFTR', 1, 1, 1, 0, 0),
        29: ('GRAC', 1, 1, 0, 0, 0),
        30: ('GRAS', 1, 1, 0, 0, 0),
        31: ('GRAT', 1, 1, 0, 0, 0),
        32: ('GRBS', 1, 1, 0, 0, 0),
        33: ('GRCO', 1, 1, 1, 0, 0),
        34: ('GRDH', 1, 1, 0, 0, 0),
        35: ('GRDN', 1, 1, 0, 0, 0),
        36: ('GREX', 1, 1, 0, 0, 0),
        37: ('GRHN', 1, 1, 1, 0, 0),
        38: ('GRIE', 1, 1, 0, 0, 0),
        39: ('GRII', 1, 1, 0, 0, 0),
        40: ('GRIN', 1, 1, 0, 0, 0),
        41: ('GRIP', 1, 1, 0, 0, 0),
        42: ('GRIS', 1, 1, 0, 0, 0),
        43: ('GRIV', 1, 1, 0, 0, 0),
        44: ('GRLO', 1, 1, 0, 0, 0),
        45: ('GRME', 1, 1, 1, 0, 0),
        46: ('GRNC', 1, 1, 0, 0, 0),
        47: ('GRNS', 1, 1, 0, 0, 0),
        48: ('GRSE', 1, 1, 0, 0, 0),
        49: ('GRSN', 1, 1, 0, 0, 0),
        50: ('MSAC', 1, 1, 1, 1, 0),
        51: ('MSGO', 1, 1, 1, 0, 0),
        52: ('MSTY', 1, 1, 0, 0, 0),
        53: ('RCDP', 1, 1, 1, 0, 0),
        54: ('RCIT', 1, 1, 1, 0, 0),
        55: ('RCLP', 1, 1, 1, 1, 0),
        56: ('RCMG', 1, 1, 1, 0, 0),
        57: ('RCNP', 1, 1, 1, 1, 0),
        58: ('RCPF', 1, 1, 1, 1, 0),
        59: ('RCPP', 1, 1, 0, 0, 0),
        60: ('RCPT', 1, 1, 1, 1, 0),
        61: ('RCPV', 1, 1, 0, 0, 0),
        62: ('RCRR', 1, 1, 1, 1, 0),
        63: ('RCTS', 1, 1, 1, 1, 0),
        64: ('RIPC', 1, 1, 0, 0, 0),
        65: ('RIRC', 1, 1, 0, 0, 0),
        66: ('RIRO', 1, 1, 0, 0, 0),
        67: ('RIVL', 1, 1, 0, 0, 0),
        68: ('RIVP', 1, 1, 0, 0, 0),
        69: ('RUFL', 1, 1, 0, 0, 0),
        70: ('RUFP', 1, 1, 0, 0, 0),
        71: ('SCPG', 1, 1, 1, 0, 0),
        72: ('SCSS', 1, 1, 1, 1, 0),
    }
    sql = "USE RCMS;\nGO\nINSERT INTO Django.guardian_groupobjectpermission\n    " \
          "(object_pk, content_type_id, group_id, permission_id))\nVALUES\n{}"

    ids_query = ("Select id, content_type_id From RCMS_OLD.Django.auth_permission "
                 "WHERE name='Can send command' AND codename='send_command'")
    answer = get_query_answer(connection, ids_query)
    permission_id, content_type_id = answer['id'], answer['content_type_id']
    obj = f"    ({{}}, {content_type_id}, {{}}, {permission_id}),\n"
    s = ""
    for pk, fields in p.items():
        if fields[1] == 1:
            s += obj.format(pk, 1)
        if fields[2] == 1:
            s += obj.format(pk, 2)
        if fields[3] == 1:
            s += obj.format(pk, 3)
        if fields[4] == 1:
            s += obj.format(pk, 4)
        if fields[5] == 1:
            s += obj.format(pk, 5)
    query = sql.format(s)[:-2] + ';'
    with open('32_Fill_Group_Permissions.sql', 'w') as f:
        f.write(query)


if __name__ == '__main__':
    # make_group_permission_file()
    load_and_run('.')
