-- ##Title web-保存选中的行政区域列表
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-保存选中的行政区域列表
-- ##CallType[ExSql]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input bizGuid char[36] NOTNULL;业务guid，必填
-- ##input parentCode string[30] NOTNULL;区域父级code，必填
-- ##input code string[30] NOTNULL;区域code，必填
-- ##input allParentCode string[200] NOTNULL;组系节点code，必填
-- ##input bizCode string[6] NOTNULL;业务code，必填

insert into coz_biz_city_{url:[http://127.0.0.1:8011/html?SqlCmdName=aprc\base\getCodeTable_1_0_1&bizCode={bizCode}&DBC=w_a]/url}_temp(guid,biz_guid,nparent_code,ncode,all_parent_code,create_by,create_time)
select
    UUID()
     ,'{bizGuid}'
     ,'{parentCode}'
     ,'{code}'
     ,'{allParentCode}'
     ,'{curUserId}'
     ,now()
from
    coz_guidance_criterion
where not exists(select 1 from coz_biz_city_{url:[http://127.0.0.1:8011/html?SqlCmdName=aprc\base\getCodeTable_1_0_1&bizCode={bizCode}&DBC=w_a]/url}_temp where biz_guid='{bizGuid}' and ncode='{code}'and active_flag='0' and del_flag='0')
limit 1
;


