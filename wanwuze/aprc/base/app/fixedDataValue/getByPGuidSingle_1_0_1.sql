-- ##Title app-单选-固化字段内容节点根据父节点code逐层获取子级数据
-- ##Author 卢文彪
-- ##CreateTime 2023-11-06
-- ##Describe 当业务code是 c2开头时,例如 'c20001',则请求该接口获取字段内容数据
-- ##Describe 提交渠道需求,提交办理申请(非二维码)功能处使用
-- ##CallType[QueryData]

-- ##input bizCode char[6] NOTNULL;业务字段内容code(例如:'c20001')，必填
-- ##input nodeParentCode string[36] NOTNULL;父节点code(也是节点guid,一级传0)，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output nodeHasSon enum[0,1] 1;是否有儿子节点（0-否，1-是，后端根据区域最大层级计算是否当前节点有儿子）
-- ##output nodeCode string[20] 1;节点code
-- ##output nodeParentCode string[20] 1;父节点code
-- ##output nodePathName string[200] 1;节点全路径名称
-- ##output nodeName string[20] 1;节点名称

# 根据业务guid计算当前需要查询几级数据
set @maxlevel = (select max(`level`)
                 from coz_model_fixed_data t1
                          inner join coz_model_fixed_data_value t2 on t1.guid = t2.fixed_data_guid
                 where t1.code = '{bizCode}'
                   and t1.del_flag = '0'
                   and t2.del_flag = '0');

select case
           when (@maxlevel > t2.level and end_nodes_count > 0) then '1' -- 业务需要的最大层级大于结果节点的层级且结果节点的子孙数量大于0，则表示有儿子
           else '0' end as nodeHasSon
     , level
     , t2.guid           as nodeCode
     , t2.id
     , parent_guid      as nodeParentCode
     , path_value       as nodePathName
     , `value`          as nodeName
from coz_model_fixed_data t1
         inner join coz_model_fixed_data_value t2 on t1.guid = t2.fixed_data_guid
where t2.parent_guid = '{nodeParentCode}'
  and t1.del_flag = '0'
  and t2.del_flag = '0'
  and t1.code = '{bizCode}'
order by id;

