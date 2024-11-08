-- ##Title app-单选-根据父节点code逐层获取子级数据

-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe 前端:固化字段内容多选且是行政区域相关、企业业务类型、行业国标的用此接口获取数据,相关code枚举: 'c00008'、'c00009'、'c00010'、'c00011'、'c00012'、'c00021'、'c00022'、'c00023'、'c00020'、'c00024'
-- ##CallType[QueryData]

-- ##input bizCode char[6] NOTNULL;业务字段内容code(例如:'c00008'、'c00009'、'c00010'、'c00011'、'c00012'、'c00021'、'c00022'、'c00023'、'c00020'、'c00024')，必填
-- ##input nodeParentCode string[20] NOTNULL;父节点code，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output nodeHasSon enum[0,1] 1;是否有儿子节点（0-否，1-是，后端根据区域最大层级计算是否当前节点有儿子）
-- ##output nodeCode string[20] 1;节点code
-- ##output nodeParentCode string[20] 1;父节点code
-- ##output parentCode string[20] 1;父节点code
-- ##output nodePathName string[200] 1;节点全路径名称
-- ##output nodeName string[20] 1;节点名称

# 根据业务code计算当前需要查询几级数据
set @maxlevel = (select case
                            when ('{bizCode}' = 'c00008') then 0
                            when ('{bizCode}' = 'c00009') then 1
                            when ('{bizCode}' = 'c00010') then 2
                            when ('{bizCode}' = 'c00011' or '{bizCode}' = 'c00022' or '{bizCode}' = 'c00023') then 3
                            when ('{bizCode}' = 'c00012') then 4
                            when ('{bizCode}' = 'c00021') then 5
                            when ('{bizCode}' = 'c00020') then 3
                            when ('{bizCode}' = 'c00024') then 4
                            else 0 end)
;


select case
           when (@maxlevel > t.level and end_nodes_count > 0) then '1' -- 业务需要的最大层级大于结果节点的层级且结果节点的子孙数量大于0，则表示有儿子
           else '0' end as nodeHasSon
     , level
     , code             as nodeCode
     , id
     , parent_code      as nodeParentCode
     , path_name        as nodePathName
     , name             as nodeName
     , `level`          as nodeLevel
from {url:[http://127.0.0.1:8011/html?SqlCmdName=aprc\base\getCodeTable_1_0_1&bizCode={bizCode}&DBC=w_a]/url} t
where 1=1  {dynamic:nodeParentCode[and t.parent_code = '{nodeParentCode}']/dynamic} {dynamic:parentCode[and t.parent_code = '{parentCode}']/dynamic}
order by id;

