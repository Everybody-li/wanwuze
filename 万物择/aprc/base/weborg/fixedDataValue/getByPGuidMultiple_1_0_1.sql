-- ##Title web-多选-固化字段内容节点-逐级获取列表
-- ##Author 卢文彪
-- ##CreateTime 2023-11-06
-- ##Describe  前端: 当业务code是 c2开头时,例如 'c20001',则请求该接口获取字段内容数据
-- ##Describe  前端: web端供应机构,web后台运营经理,web后台型号专员处: 按单需求范围,型号需求范围,供应报价功能处使用
-- ##CallType[QueryData]

-- ##input bizCode char[6] NOTNULL;业务字段内容code(例如:'c20001')
-- ##input bizGuid char[36] NOTNULL;业务guid
-- ##input nodeParentCode string[36] NOTNULL;父节点code(也是guid,一级传0)
-- ##input curUserId string[36] NOTNULL;登录用户id

-- ##output nodeSelectedFlag string[1] 1;节点勾选状态（0-未勾选，1-已勾选）
-- ##output nodeCode string[36] 1;节点code
-- ##output nodeParentCode string[36] 1;父节点code
-- ##output nodeAllParentCode string[200] 1;组系父节点code
-- ##output nodePathName string[200] 1;节点全路径名称
-- ##output nodeName string[20] 1;节点名称
-- ##output nodeHasSon string[1] 1;是否有儿子节点（0-否，1-是，后端根据区域最大层级计算是否当前节点有儿子）

# 根据入参bizCode计算当前请求的行政区域为几级
set @maxlevel = (select max(`level`)
                 from coz_model_fixed_data t1
                          inner join coz_model_fixed_data_value t2 on t1.guid = t2.fixed_data_guid
                 where t1.code = '{bizCode}'
                   and t1.del_flag = '0'
                   and t2.del_flag = '0');

select case
           when ((baseChildrenCount = bizChildrenCount and bizChildrenCount > 0))
               then '2' -- 勾选
           when ((baseChildrenCount > bizChildrenCount and bizChildrenCount > 0))
               then '1' -- 半选
           when (bizChildrenCount = 0)
               then '0' -- 未选
           else '0' -- 未选
    end as nodeSelectedFlag
     , t.nodeCode
     , t.nodeParentCode
     , t.nodeAllParentCode
     , t.nodePathName
     , t.nodeName
     , t.nodeHasSon
from (select case
                 when @maxlevel > level and end_nodes_count > 0
                     then '1' -- 需要请求的层级大于结果节点层级 且 结果节点的子孙节点数量大于0，则表示结果节点有儿子(草稿节点)
                 else '0' end                              as nodeHasSon
           , IF((end_nodes_count = 0), 1, end_nodes_count) as baseChildrenCount -- 结果节点在基础表的子孙节点数量(草稿节点)
           , ifnull((select sum(case when (end_nodes_count = 0) then 1 else end_nodes_count end)
                     from coz_model_fixed_data_value
                     where guid in (select nguid
                                    from coz_model_fixed_data_value_temp
                                    where biz_guid = '{bizGuid}'
                                      and active_flag = '0'
                                      and (nguid = t.guid
                                        or all_parent_id like concat('%,'
                                            , t.id
                                            , ',%')))), 0) as bizChildrenCount  -- 结果节点在业务表的子孙节点数量(草稿节点)
           , t.guid                                        as nodeCode
           , t.id
           , parent_guid                                   as nodeParentCode
           , all_parent_id                                 as nodeAllParentCode
           , path_value                                    as nodePathName
           , `value`                                       as nodeName
      from coz_model_fixed_data t1
               inner join coz_model_fixed_data_value t on t1.guid = t.fixed_data_guid
      where t.parent_guid = '{nodeParentCode}'
        and t1.code = '{bizCode}'
        and t1.del_flag = '0'
        and t.del_flag = '0') t
order by id;
