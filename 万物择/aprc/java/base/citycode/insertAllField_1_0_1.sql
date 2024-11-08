-- ##Title 新增行政区域数据
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe 新增行政区域数据
-- ##CallType[ExSql]

-- ##input id int[>=-1] NOTNULL;名称，必填
-- ##input guid string[12] NOTNULL;编码，必填
-- ##input all_parent_id string[200] NOTNULL;父节点编码，必填
-- ##input path_name string[200] NOTNULL;全路径名称，必填
-- ##input name string[100] NOTNULL;层级，必填
-- ##input code string[30] NOTNULL;层级，必填
-- ##input parent_code string[30] NOTNULL;层级，必填
-- ##input all_parent_code string[200] NOTNULL;层级，必填
-- ##input level int[>=-1] NOTNULL;层级，必填
-- ##input endNodesCount int[>=0] NOTNULL;叶子节点数量，必填


insert into sys_city_code (id,
                           guid,
                           all_parent_id,
                           path_name, name,
                           code,
                           parent_code,
                           all_parent_code,
                           level,
                           version,
                           end_nodes_count,
                           create_time)
values ({id},
        '{guid}',
        '{all_parent_id}',
        '{path_name}',
        '{name}',
        '{code}',
        '{parent_code}',
        '{all_parent_code}',
        {level},
        1,
        {end_nodes_count},
        now());