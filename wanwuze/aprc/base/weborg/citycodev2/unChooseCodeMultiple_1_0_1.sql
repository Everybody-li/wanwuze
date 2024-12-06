-- ##Title web-多选-行政区域节点去勾
-- ##Author lith
-- ##CreateTime 2023-06-15

-- ##Describe 前端:固化字段内容多选且是行政区域相关、企业业务类型、行业国标的用此接口获取数据,相关code枚举: 'c00008'、'c00009'、'c00010'、'c00011'、'c00012'、'c00021'、'c00022'、'c00023'、'c00020'、'c00024'
-- ##CallType[QueryData]

-- ##input bizCode char[6] NOTNULL;业务字段内容code(例如:'c00008'、'c00009'、'c00010'、'c00011'、'c00012'、'c00021'、'c00022'、'c00023'、'c00020'、'c00024')，必填
-- ##input bizGuid char[36] NOTNULL;业务guid，必填
-- ##input nodeCode string[20] NOTNULL;节点code，必填
-- ##input nodeParentCode string[20] NOTNULL;父节点code，必填
-- ##input nodeAllParentCode string[200] NOTNULL;组系节点code，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

set @nodeParentCodeSelectedFlag=0;
select 1 into @nodeParentCodeSelectedFlag from {url:[http://127.0.0.1:8011/html?SqlCmdName=aprc\base\getCodeTempTable_1_0_1&bizCode={bizCode}&DBC=w_a]/url}
where  biz_guid = '{bizGuid}' and ncode = '{nodeParentCode}' and active_flag = '0';


# 删除当前节点(草稿状态)
delete from {url:[http://127.0.0.1:8011/html?SqlCmdName=aprc\base\getCodeTempTable_1_0_1&bizCode={bizCode}&DBC=w_a]/url}
where  biz_guid = '{bizGuid}' and ncode = '{nodeCode}' and active_flag='0'
;
# 删除当前节点儿子节点(有儿子才删除，且删除草稿状态的)
delete from {url:[http://127.0.0.1:8011/html?SqlCmdName=aprc\base\getCodeTempTable_1_0_1&bizCode={bizCode}&DBC=w_a]/url}
where  {nodeHasSon} = 1 and biz_guid = '{bizGuid}' and nparent_code = '{nodeCode}' and active_flag='0'
;

# 删除当前节点组系节点(删除草稿状态的)
# delete from coz_biz_city_{url:[http://127.0.0.1:8011/html?SqlCmdName=aprc\base\getCodeTable_1_0_1&bizCode={bizCode}&DBC=w_a]/url}_temp
# where   biz_guid = '{bizGuid}' and   '{nodeAllParentCode}' like concat('%',all_parent_code,'%') and active_flag='0';

call unChooseNode_{url:[http://127.0.0.1:8011/html?SqlCmdName=aprc\base\getCodeTable_1_0_1&bizCode={bizCode}&DBC=w_a]/url} ('{bizGuid}','{nodeParentCode}','{nodeAllParentCode}','{nodeCode}','{curUserId}');




