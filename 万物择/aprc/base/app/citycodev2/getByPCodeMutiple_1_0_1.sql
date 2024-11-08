-- ##Title app-多选-根据父节点code查询儿子列表(区县)
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-多选-根据父节点code查询儿子列表(区县)
-- ##CallType[QueryData]

-- ##input bizGuid string[36] NOTNULL;业务guid，必填
-- ##input bizCode string[30] NOTNULL;父级code，必填
-- ##input nodeCode string[11] NOTNULL;节点code(顶级传0)，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

# 根据业务code计算当前需要查询几级数据
set @maxlevel = (select case
                            when ('{bizCode}' = 'c00011') then 3
                            else 0 end)
;
select 
parent_code as nodeParentCode
,path_name as nodePathName
,name as nodeName
,code as nodeCode
,all_parent_code as nodeAllParentCode
,case when (@maxlevel > t.level and end_nodes_count > 0) then '1' -- 业务需要的最大层级大于结果节点的层级且结果节点的子孙数量大于0，则表示有儿子
else '0' end as nodeHasSon
,case when exists(select 1 from coz_biz_city_code_temp where biz_guid='{bizGuid}' and ncode=t.code) then '1' else '0' end as nodeSelectedFlag
from sys_city_code t
where t.parent_code = '{nodeCode}'
order by id;

