-- ##Title web-多选-固化字段内容节点打勾
-- ##Author lith
-- ##CreateTime 2023-11-06
-- ##Describe  coz_model_fixed_data t1,coz_model_fixed_data_value t2
-- ##Describe  前端: 当业务code是 c2开头时,例如 'c20001',则请求该接口获取字段内容数据
-- ##Describe  前端: web端供应机构,web后台运营经理,web后台型号专员处: 按单需求范围,型号需求范围,供应报价功能处使用
-- ##CallType[QueryData]

-- ##input bizCode char[6] NOTNULL;业务字段内容code(例如:'c20001')
-- ##input bizGuid char[36] NOTNULL;业务guid
-- ##input nodeHasSon enum[0,1] NOTNULL;节点是否有儿子
-- ##input nodeCode string[36] NOTNULL;节点code(也是节点guid)
-- ##input nodeParentCode string[36] NOTNULL;父节点code(也是节点guid)
-- ##input nodeAllParentCode string[200] NOTNULL;组系节点code(也是组系节点id)
-- ##input curUserId string[36] NOTNULL;登录用户id


# 删除当前节点儿子节点(有儿子才删除，且删除草稿状态的)
delete
from coz_model_fixed_data_value_temp
where {nodeHasSon} = 1
  and biz_guid = '{bizGuid}'
  and all_parent_id like concat('%,', '{nodeCode}', ',%')
  and active_flag = '0';


# 新增当前节点(草稿状态）
insert into coz_model_fixed_data_value_temp (guid,
                                             biz_guid,
                                             nparent_guid,
                                             nguid,
                                             all_parent_id,
                                             create_by,
                                             create_time)
select uuid(),
       '{bizGuid}',
       '{nodeParentCode}',
       '{nodeCode}',
       '{nodeAllParentCode}',
       '{curUserId}',
       current_timestamp()
where not exists(select 1
                 from coz_model_fixed_data_value_temp
                 where biz_guid = '{bizGuid}'
                   and nguid = '{nodeCode}'
                   and active_flag = '0');

call transAllChild2Parent_fixedDataValue('{bizGuid}', '{nodeParentCode}', '{curUserId}');

#  查询当前节点父节点的选中状态(草稿状态)
# select case
#            when (bizChildrenCount = 0)
#                then '0' -- 未选
#            when ((baseChildrenCount > bizChildrenCount and bizChildrenCount > 0))
#                then '1' -- 半选
#            when ((baseChildrenCount = bizChildrenCount and bizChildrenCount > 0))
#                then '2' -- 选中
#            else '0'
#            end as nodeParentSelectedFlag
# from (select case
#                  when @maxlevel > level and end_nodes_count > 0
#                      then '1' -- 需要请求的层级大于结果节点层级 且 结果节点的子孙节点数量大于0，则表示结果节点有儿子(草稿节点)
#                  else '0' end                              as nodeHasSon
#            , IF((end_nodes_count = 0), 1, end_nodes_count) as baseChildrenCount -- 结果节点在基础表的子孙节点数量(草稿节点)
#            , ifnull((select sum(case when (end_nodes_count = 0) then 1 else end_nodes_count end)
#                      from coz_model_fixed_data_value
#                      where guid in (select nguid
#                                     from coz_model_fixed_data_value_temp
#                                     where biz_guid = '{bizGuid}'
#                                       and active_flag = '0'
#                                       and (nguid = t.guid
#                                         or all_parent_id like concat('%,'
#                                             , t.id
#                                             , ',%')))), 0) as bizChildrenCount  -- 结果节点在业务表的子孙节点数量(草稿节点)
#       from coz_model_fixed_data t1
#                inner join coz_model_fixed_data_value t on t1.guid = t.fixed_data_guid
#       where t.parent_guid = '0'
#         and t1.code = '{bizCode}'
#         and t1.del_flag = '0'
#         and t.del_flag = '0') t
# ;

