Select
    dau.username,
    dag.name,
    cki.CKey,
    ap.codename
From Django.account_user dau
    JOIN Django.account_user_groups aug on dau.id = aug.user_id
    JOIN Django.auth_group dag on dag.id = aug.group_id
    JOIN Django.guardian_groupobjectpermission gg on dag.id = gg.group_id
    JOIN Django.account_sendkeycommand ask ON gg.object_pk = ask.id
    JOIN Command.KeyInformation cki ON ask.Key_id = cki.id
    JOIN Django.auth_permission ap ON gg.permission_id = ap.id
WHERE dau.id = {} AND cki.id = {} AND ap.codename = '{}'
